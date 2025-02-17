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
 * MeasurementUnit Model
 */
class MeasurementUnit extends Model
{
    /* Generated Fields:
     * id(uuid)
     * name(character varying)
     * short_name(character varying)
     * uses_quantity(boolean)
     * server_id(uuid)
     * created_at_event_id(uuid)
     * created_by_user_id(uuid)
     * response(text)
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
    public $table = 'acorn_lojistiks_measurement_units';

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
    protected $dates = [];

    /**
     * @var array Relations
     */
    public $hasOne = [];
    public $hasMany = [
        'lojistiks_products_measurement_unit' => [\Acorn\Lojistiks\Models\Product::class, 'key' => 'measurement_unit_id', 'type' => '1fromX']
    ];
    public $hasOneThrough = [];
    public $hasManyThrough = [];
    public $belongsTo = [
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
    public $attachOne = [];
    public $attachMany = [];

    public static function menuitemCount() {
        # Auto-injected by acorn-create-system
        return self::all()->count();
    }
}
// Created By acorn-create-system v1.0
