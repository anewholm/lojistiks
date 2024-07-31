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
        'address'     => [Address::class, 'key' => 'server_id'],
        'areas'     => [Area::class, 'key' => 'server_id'],
        'area_types'     => [AreaType::class, 'key' => 'server_id'],
        'brands'     => [Brand::class, 'key' => 'server_id'],
        'computer_products'     => [ComputerProduct::class, 'key' => 'server_id'],
        'drivers'     => [Driver::class, 'key' => 'server_id'],
        'electronic_products'     => [ElectronicProduct::class, 'key' => 'server_id'],
        'gps'     => [GPS::class, 'key' => 'server_id'],
        'locations'     => [Location::class, 'key' => 'server_id'],
        'measurement_units'     => [MeasurementUnit::class, 'key' => 'server_id'],
        'offices'     => [Office::class, 'key' => 'server_id'],
        'persons'     => [Person::class, 'key' => 'server_id'],
        'products'  => [Product::class, 'key' => 'server_id'],
        'product_instances'  => [ProductInstance::class, 'key' => 'server_id'],
        'suppliers'  => [Supplier::class, 'key' => 'server_id'],
        'transfers'  => [Transfer::class, 'key' => 'server_id'],
        'vehicle'  => [Vehicle::class, 'key' => 'server_id'],
        'warehouses'  => [Warehouse::class, 'key' => 'server_id'],

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

    public static function menuitemCount()
    {
        return self::all()->count();
    }
}
