<?php

namespace AcornAssociated\Lojistiks\Models;

use AcornAssociated\Model;
use Illuminate\Database\Eloquent\Collection;

/**
 * Location Model
 */
class Location extends Model
{
    use \Winter\Storm\Database\Traits\Validation;

    /**
     * @var string The database table used by the model.
     */
    public $table = 'acornassociated_lojistiks_locations';

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
        'offices'     => Office::class,
        'suppliers'   => Supplier::class,
        'warehouses'  => Warehouse::class,
        'employees'      => Employee::class,
        'transfers_in'   => [Transfer::class, 'key' => 'destination_location_id'],
        'transfers_out'  => [Transfer::class, 'key' => 'source_location_id'],
        'stock'          => Stock::class,
        'stock_products' => StockProduct::class,
    ];
    public $hasOneThrough = [];
    public $hasManyThrough = [];
    public $belongsTo = [
        'address' => Address::class,
        'server'  => Server::class,
    ];
    public $belongsToMany = [];
    public $morphTo = [];
    public $morphOne = [];
    public $morphMany = [];
    public $attachOne = [];
    public $attachMany = [];

    protected function getFullyQualifiedNameAttribute()
    {
        $this->load('address');
        $addressFQName = $this->address?->fullyQualifiedName();
        return "$this->name, $addressFQName";
    }

    public function fullyQualifiedName()
    {
        return $this->fully_qualified_name;
    }
}