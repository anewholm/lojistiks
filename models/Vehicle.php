<?php

namespace Acorn\Lojistiks\Models;

use Acorn\Model;
use Acorn\Models\Server;
use System\Models\File;

/**
 * Vehicle Model
 */
class Vehicle extends Model
{
    use \Winter\Storm\Database\Traits\Validation;

    /**
     * @var string The database table used by the model.
     */
    public $table = 'acorn_lojistiks_vehicles';

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
        'registration' => 'required',
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
        'transfers' => Transfer::class,
    ];
    public $hasOneThrough = [
        'last_transfer' => [
            Transfer::class,
            'through' => VehicleLast::class,
            'throughKey' => 'vehicle_id',
        ],
    ];
    public $hasManyThrough = [];
    public $belongsTo = [
        'vehicle_type' => VehicleType::class,
        'initial_transfer' => Transfer::class,
        'server' => Server::class,
    ];
    public $belongsToMany = [];
    public $morphTo = [];
    public $morphOne = [];
    public $morphMany = [];
    public $attachOne = [
        'image' => File::class,
    ];
    public $attachMany = [];

    public function getFullNameAttribute()
    {
        $this->load('vehicle_type');
        $type = $this->vehicle_type->name();
        return "$this->registration ($type)";
    }

    public function fullName()
    {
        return $this->full_name;
    }

    public static function menuitemCount()
    {
        return self::all()->count();
    }
}
