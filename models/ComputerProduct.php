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
 * ComputerProduct Model
 */
class ComputerProduct extends Model
{
    /* Generated Fields:
     * id(uuid)
     * electronic_product_id(uuid)
     * memory(bigint)
     * HDD_size(bigint)
     * processor_version(double precision)
     * server_id(uuid)
     * created_at_event_id(uuid)
     * created_by_user_id(uuid)
     * processor_type(integer)
     * response(text)
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
    public $table = 'product.acorn_lojistiks_computer_products';

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
        'electronic_product' => 'required'
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
    public $hasMany = [];
    public $hasOneThrough = [];
    public $hasManyThrough = [];
    public $belongsTo = [
        'electronic_product' => [\Acorn\Lojistiks\Models\ElectronicProduct::class, 'key' => 'electronic_product_id', 'name' => TRUE, 'type' => '1to1'],
        'server' => [\Acorn\Models\Server::class, 'key' => 'server_id', 'type' => 'Xto1'],
        'created_at_event' => [\Acorn\Calendar\Models\Event::class, 'key' => 'created_at_event_id', 'type' => 'Xto1'],
        'created_by_user' => [\Acorn\User\Models\User::class, 'key' => 'created_by_user_id', 'type' => 'Xto1']
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
