<?php

namespace Acorn\Lojistiks\Models;

use Acorn\Lojistiks\Classes\QRCodeModel;
use Flash;
use Illuminate\Database\Eloquent\Collection;

/**
 * Transfer Model
 */
class Transfer extends QRCodeModel
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
}
