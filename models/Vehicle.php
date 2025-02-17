<?php

namespace Acorn\Lojistiks\Models;

use Acorn\Models\Server;
use Acorn\Collection;
use BackendAuth;
use \Backend\Models\User;
use \Backend\Models\UserGroup;
use Exception;
use Flash;


use Acorn\Model;

/**
 * Vehicle Model
 */
class Vehicle extends Model
{
    /* Generated Fields:
     * id(uuid)
     * vehicle_type_id(uuid)
     * registration(character varying)
     * server_id(uuid)
     * created_at_event_id(uuid)
     * created_by_user_id(uuid)
     * response(text)
     * image(path)
     * description(text)
     * updated_at_event_id(uuid)
     * updated_by_user_id(uuid)
     */

    public $hasManyDeep = [];
    public $actionFunctions = [];
    use \Winter\Storm\Database\Traits\Revisionable;
    use \Illuminate\Database\Eloquent\Concerns\HasUuids;


    protected $revisionable = [];
    public $timestamps = 0;
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
        'vehicle_type' => 'required',
        'registration' => 'required'
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
    protected $dates = [];

    /**
     * @var array Relations
     */
    public $hasOne = [];
    public $hasMany = [
        'lojistiks_transfers_vehicle' => [\Acorn\Lojistiks\Models\Transfer::class, 'key' => 'vehicle_id', 'type' => '1fromX'],
        'lojistiks_drivers_vehicle' => [\Acorn\Lojistiks\Models\Driver::class, 'key' => 'vehicle_id', 'type' => '1fromX']
    ];
    public $hasOneThrough = [];
    public $hasManyThrough = [];
    public $belongsTo = [
        'vehicle_type' => [\Acorn\Lojistiks\Models\VehicleType::class, 'key' => 'vehicle_type_id', 'type' => 'Xto1'],
        'server' => [\Acorn\Models\Server::class, 'key' => 'server_id', 'type' => 'Xto1'],
        'created_at_event' => [\Acorn\Calendar\Models\Event::class, 'key' => 'created_at_event_id', 'type' => 'Xto1'],
        'created_by_user' => [\Acorn\User\Models\User::class, 'key' => 'created_by_user_id', 'type' => 'Xto1'],
        'updated_at_event' => [\Acorn\Calendar\Models\Event::class, 'key' => 'updated_at_event_id', 'type' => 'Xto1'],
        'updated_by_user' => [\Acorn\User\Models\User::class, 'key' => 'updated_by_user_id', 'type' => 'Xto1']
    ];
    public $belongsToMany = [];
    public $morphTo = [];
    public $morphOne = [];
    public $morphMany = [
        'revision_history' => ['System\Models\Revision', 'name' => 'revisionable']
    ];
    public $attachOne = [
        'image' => 'System\Models\File'
    ];
    public $attachMany = [];

    public static function menuitemCount() {
        # Auto-injected by acorn-create-system
        return self::all()->count();
    }

    public function name() {
        # Auto-injected by acorn-create-system
        return $this->registration;
    }
}
// Created By acorn-create-system v1.0
