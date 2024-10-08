<?php

namespace Acorn\Lojistiks\Models;

use Acorn\Model;
use Acorn\Models\Server;
use System\Models\File;

use Acorn\Oil\Models\Refinery;
use Acorn\Oil\Models\GasStation;
use Acorn\Oil\Models\OilDepot;

// Useful
use BackendAuth;
use \Backend\Models\User;
use \Backend\Models\UserGroup;
use Exception;
use Flash;

/**
 * Location Model
 */
class Location extends Model
{
    use \Winter\Storm\Database\Traits\Validation;

    // public $translatable = ['name', 'address[name]'];

    /**
     * @var string The database table used by the model.
     */
    public $table = 'acorn_lojistiks_locations';

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
        'name' => 'required',
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
    public $hasOne = [
        'office'       => [Office::class,     'leaf' => TRUE],
        'supplier'     => [Supplier::class,   'leaf' => TRUE],
        'warehouse'    => [Warehouse::class,  'leaf' => TRUE],
    ];
    public $hasMany = [
        'employees'      => Employee::class,
        'transfers_in'   => [Transfer::class, 'key' => 'destination_location_id'],
        'transfers_out'  => [Transfer::class, 'key' => 'source_location_id'],
        'stock'          => Stock::class,
        'stock_products' => StockProduct::class,
        // TODO: Move these vehicles in to $hasManyThrough
        'vehicles'       => VehicleLast::class,
    ];
    public $hasOneThrough = [];
    public $hasManyThrough = [

    ];
    public $belongsTo = [
        'address' => Address::class,
        'user_group' => UserGroup::class,
        'server'  => Server::class,
    ];
    public $belongsToMany = [];
    public $morphTo = [];
    public $morphOne = [];
    public $morphMany = [];
    public $attachOne = [
        'image' => File::class,
    ];
    public $attachMany = [];

    protected function getFullyQualifiedNameAttribute()
    {
        $this->load('address');
        $addressFQName = $this->address->fullyQualifiedName();
        $leafLocation  = $this->getLeafTypeModel();
        $leafLocationName = ($leafLocation ? $leafLocation->name() : $this->name());
        // $leafLocationID   = $leafLocation?->id();
        // $thisID           = $this->id();
        // $leafLocationName .= "($leafLocationID/$thisID)";

        return "$leafLocationName, $addressFQName";
    }

    public function fullyQualifiedName()
    {
        return $this->fully_qualified_name;
    }
}
