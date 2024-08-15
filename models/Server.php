<?php

namespace Acorn\Lojistiks\Models;

use Acorn\Model;

/**
 * server Model
 */
class Server extends Model
{
    use \Winter\Storm\Database\Traits\Validation;

    /**
     * @var string The database table used by the model.
     */
    public $table = 'acorn_lojistiks_servers';

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
        'address'     => Address::class,
        'areas'     => Area::class,
        'area_types'     => AreaType::class,
        'brands'     => Brand::class,
        'computer_products'     => ComputerProduct::class,
        'drivers'     => Driver::class,
        'electronic_products'     => ElectronicProduct::class,
        'gps'     => GPS::class,
        'locations'     => Location::class,
        'measurement_units'     => MeasurementUnit::class,
        'offices'     => Office::class,
        'persons'     => Person::class,
        'products'  => Product::class,
        'product_instances'  => ProductInstance::class,
        'suppliers'  => Supplier::class,
        'transfers'  => Transfer::class,
        'vehicle'  => Vehicle::class,
        'warehouses'  => Warehouse::class,
    ];
    public $hasOneThrough = [];
    public $hasManyThrough = [];
    public $belongsTo = [];
    public $belongsToMany = [];
    public $morphTo = [];
    public $morphOne = [];
    public $morphMany = [];
    public $attachOne = [];
    public $attachMany = [];

    public function getNameAttribute()
    {
        $isLocal = ($this->replicated() ? '*' : '');
        return "$this->hostname$isLocal";
    }

    public function name()
    {
        return $this->name;
    }

    public function getReplicatedAttribute()
    {
        return (gethostname() != $this->hostname);
    }

    public function replicated()
    {
        return $this->replicated;
    }

    public function getReplicatedSourceAttribute()
    {
        return ($this->replicated() ? $this->hostname : '');
    }

    public function replicatedSource()
    {
        return $this->replicated_source;
    }

    public static function menuitemCount()
    {
        return self::all()->count();
    }
}
