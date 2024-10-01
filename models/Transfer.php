<?php

namespace Acorn\Lojistiks\Models;

use Acorn\Model;
use Acorn\Models\Server;
use Str;
use Illuminate\Database\Eloquent\Collection;
use Acorn\Finance\Models\Invoice;
use Acorn\Finance\Models\Purchase;

// Useful
use BackendAuth;
use Acorn\User\Models\User;
use Acorn\User\Models\UserGroup;
use Exception;
use Flash;

/**
 * Transfer Model
 */
class Transfer extends Model
{
    use \Winter\Storm\Database\Traits\Validation;

    /**
     * @var string The database table used by the model.
     */
    public $table = 'acorn_lojistiks_transfers';

    /**
     * @var array Guarded fields
     */
    protected $guarded = [];

    /**
     * @var array Fillable fields
     */
    protected $fillable = [];

    /**
     * @var array Validation rules for attributes
     */
    public $rules = [
        'source_location' => 'required',
        'destination_location' => 'required',
    ];

    /**
     * @var array Attributes to be cast to native types
     */
    protected $casts = [];

    /**
     * @var array Attributes to be cast to JSON
     */
    protected $jsonable = [];

    /**
     * @var array Attributes to be appended to the API representation of the model (ex. toArray())
     */
    protected $appends = [];

    /**
     * @var array Attributes to be removed from the API representation of the model (ex. toArray())
     */
    protected $hidden = [];

    /**
     * @var array Attributes to be cast to Argon (Carbon) instances
     */
    public $timestamps = FALSE;
    protected $dates = [];

    /**
     * @var array Relations
     */
    public $hasOne = [];
    public $hasMany = [
        'product_instance_transfer' => TransferProductInstance::class,
        'vehicles' => Vehicle::class,
    ];
    public $hasOneThrough = [];
    public $hasManyThrough = [];
    public $belongsTo = [
        'source_location' => Location::class,
        'destination_location' => Location::class,
        'vehicle' => Vehicle::class,
        'driver' => Driver::class,
        'server' => Server::class,
    ];
    public $belongsToMany = [
        'product_instances' => [
            ProductInstance::class,
            'table' => 'acorn_lojistiks_product_instance_transfer',
        ],
        'invoices' => [
            Invoice::class,
            'table' => 'acorn_lojistiks_transfer_invoice',
        ],
        'purchases' => [
            Purchase::class,
            'table' => 'acorn_lojistiks_transfer_purchase',
        ],
    ];
    public $morphTo = [];
    public $morphOne = [];
    public $morphMany = [];
    public $attachOne = [];
    public $attachMany = [];

    // --------------------------------------------- Attributes
    public function getDestinationNameAttribute()
    {
        $this->load('destination_location');
        return $this->destination_location->fullyQualifiedName();
    }

    public function getSourceNameAttribute()
    {
        $this->load('source_location');
        return $this->source_location->fullyQualifiedName();
    }

    public function getFullNameAttribute()
    {
        return "$this->source_name => $this->destination_name";
    }

    public function fullName()
    {
        return $this->full_name;
    }

    public static function menuitemCount()
    {
        return self::all()->count();
    }

    // --------------------------------------------- belongsToMany[product_instances]
    public function setProductInstance(ProductInstance $pi)
    {
        $this->setProductInstances(new Collection([$pi]));
    }

    public function setProductInstances(Collection $pis)
    {
        $tpis = new Collection();
        foreach ($pis as $pi) $tpis->push(TransferProductInstance::create(['transfer' => $this, 'product_instance' => $pi]));
        $this->product_instance_transfer = $tpis;
    }

    public function singleTransferProductInstance()
    {
        if (count($this->product_instance_transfer) != 1) throw new Exception('Transfer was not singular');
        return $this->product_instance_transfer[0];
    }

    public function getProductInstanceCountAttribute()
    {
        $this->load('product_instances');
        return $this->product_instances->count();
    }

    public function getProductInstanceQuantityAttribute()
    {
        $this->load('product_instances');
        return $this->product_instances->sum('quantity');
    }

    public function getProductInstanceContentsAttribute()
    {
        $this->load('product_instances');
        return $this->product_instances->pluck('name');
    }

    public function getProductContentsAttribute()
    {
        // TODO: getProductContentsAttribute()
        $this->load('product_instances');
        return ''; //$this->product_instances->pluck('name');
    }

    public function filterFields($fields, $context = NULL)
    {
        $is_update = ($context == 'update');
        $is_create = ($context == 'create');
        $post      = post('Transfer');

        // -------------------------------------------- Last used values
        if ($is_create) {
            // TODO: Make this a plugin UserGroups Person Trait
            foreach (Person::lastsFromAuthPersonFor($this) as $name => $model) {
                if (property_exists($fields, $name) && !isset($fields->$name->value)) {
                    if (method_exists($model, 'id')) $fields->$name->value = $model->id();
                }
            }
        }

        // -------------------------------------------- Transfer[_product]
        if ($is_update || $is_create) {
            // Transfer[_product]:
            // Transfer[_quantity_to_add]:
            // Custom implementation because of quantity
            if (isset($post['_product']) && $post['_product']) {
                if ($product = Product::find($post['_product'])) {
                    $product_instances = &$fields->product_instances->value;
                    if (!is_array($product_instances)) $product_instances = array();
                    $quantity = intval($post['_quantity_to_add']);
                    $pis      = $product->createInstances($quantity); // TODO: asset class
                    $product_instances = array_merge($product_instances, $pis->ids());
                    // Clear the form
                    $fields->_product->value = NULL;
                }
            }
        }

        // -------------------------------------------- Groups
        if ($is_update || $is_create) {
            if (isset($post['_source_user_group']) && $post['_source_user_group']) {
                if ($group = UserGroup::find($post['_source_user_group'])) {
                    $locations = Location::whereBelongsTo($group, 'user_group')->get();
                    $field     = &$fields->source_location;
                    $nameFrom  = (isset($field->config['nameFrom']) ? $field->config['nameFrom'] : 'name');
                    $fields->source_location->options = $locations->lists($nameFrom);
                }
            }
            if (isset($post['_destination_user_group']) && $post['_destination_user_group']) {
                if ($group = UserGroup::find($post['_destination_user_group'])) {
                    $locations = Location::whereBelongsTo($group, 'user_group')->get();
                    $field     = &$fields->destination_location;
                    $nameFrom  = (isset($field->config['nameFrom']) ? $field->config['nameFrom'] : 'name');
                    $fields->destination_location->options = $locations->lists($nameFrom);
                }
            }
        }

        parent::filterFields($fields, $context);
    }

    public function afterCreate()
    {
        Person::saveLastsToAuthPerson([
            'source_location' => $this->source_location,
            'destination_location' => $this->destination_location,
        ], $this);
    }
}
