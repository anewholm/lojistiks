<?php

namespace Acorn\Lojistiks\Models;

use Acorn\Model;
use Illuminate\Database\Eloquent\Collection;

/**
 * ProductInstance Model
 */
class ProductInstance extends Model
{
    use \Winter\Storm\Database\Traits\Validation;

    /**
     * @var string The database table used by the model.
     */
    public $table = 'acorn_lojistiks_product_instances';

    /**
     * @var array Guarded fields
     */
    protected $guarded = ['*'];

    /**
     * @var array Fillable fields
     */
    protected $fillable = [];

    /**
     * @var array Validation rules for attributes
     */
    public $rules = [];

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
    ];
    public $hasOneThrough = [];
    public $hasManyThrough = [
        'transfers' => [
            Transfer::class,
            'through' => TransferProductInstance::class,
        ],
    ];
    public $belongsTo = [
        'product'  => Product::class,
        'server' => Server::class,
        'initial_transfer_product_instance' => [TransferProductInstance::class, 'key' => 'initial_transfer_product_instance_id'],
    ];
    public $belongsToMany = [];
    public $morphTo = [];
    public $morphOne = [];
    public $morphMany = [];
    public $attachOne = [];
    public $attachMany = [];

    public static function menuitemCount()
    {
        return self::all()->count();
    }

    public function getUsesQuantityAttribute()
    {
        $this->load('product');
        return $this->product?->usesQuantity();
    }

    public function usesQuantity()
    {
        return $this->uses_quantity;
    }

    public function getQuantityDescriptionAttribute()
    {
        $this->load('product');
        $this->product?->load('measurement_unit');
        $miName = $this->product->measurement_unit->name();
        return ($this->product?->usesQuantity() ? "$this->quantity $miName" : $miName);
    }

    public function quantityDescription()
    {
        return $this->quantity_description;
    }

    public function getNameAttribute()
    {
        $this->load('product');
        return $this->product->fullName() . " ($this->external_identifier)" . ($this->quantity == 1 ? '' : " x $this->quantity");
    }

    public function name()
    {
        return $this->name;
    }

    public function afterCreate()
    {
        // Create the initial transfer to indicate where the PI is
        $source_location      = Location::findOrFail($this->getOriginalPurgeValue('_source_location'));
        $destination_location = Location::findOrFail($this->getOriginalPurgeValue('_destination_location'));
        $tr = Transfer::create([
            'source_location'      => $source_location,
            'destination_location' => $destination_location
        ]);
        $tr->setProductInstance($this);
        $tr->save();

        // Store result
        $this->initial_transfer_product_instance = $tr->singleTransferProductInstance();
        $this->save();
    }

    public function filterFields($fields, $context = NULL)
    {
        $is_update = ($context == 'update');
        $is_create = ($context == 'create');

        if ($is_update || $is_create) {
            if ($fields->product->value) {
                $product = Product::findOrFail($fields->product->value);
                $fields->quantity->disabled            = !$product->usesQuantity();
                $fields->external_identifier->disabled = $product->usesQuantity();
            }
        }
    }
}
