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
 * ProductInstance Model
 */
class ProductInstance extends Model
{
    /* Generated Fields:
     * id(uuid)
     * product_id(uuid)
     * quantity(integer)
     * external_identifier(character varying)
     * asset_class(char)
     * server_id(uuid)
     * created_at_event_id(uuid)
     * created_by_user_id(uuid)
     * response(text)
     * image(path)
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
    public $table = 'acorn_lojistiks_product_instances';

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
        'product' => 'required',
        'asset_class' => 'max:1'
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
        'lojistiks_product_instance_transfer_product_instances_pivot' => [\Acorn\Lojistiks\Models\ProductInstanceTransfer::class, 'key' => 'product_instance_id', 'otherKey' => 'transfer_id', 'type' => 'XfromXSemi']
    ];
    public $hasOneThrough = [];
    public $hasManyThrough = [];
    public $belongsTo = [
        'product' => [\Acorn\Lojistiks\Models\Product::class, 'key' => 'product_id', 'name' => FALSE, 'type' => 'Xto1'],
        'server' => [\Acorn\Models\Server::class, 'key' => 'server_id', 'name' => FALSE, 'type' => 'Xto1'],
        'created_at_event' => [\Acorn\Calendar\Models\Event::class, 'key' => 'created_at_event_id', 'name' => FALSE, 'type' => 'Xto1'],
        'created_by_user' => [\Acorn\User\Models\User::class, 'key' => 'created_by_user_id', 'name' => FALSE, 'type' => 'Xto1']
    ];
    public $belongsToMany = [
        'lojistiks_product_instance_transfer_product_instances' => [\Acorn\Lojistiks\Models\Transfer::class, 'table' => 'acorn_lojistiks_product_instance_transfer', 'key' => 'product_instance_id', 'otherKey' => 'transfer_id', 'type' => 'XfromXSemi']
    ];
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
}
// Created By acorn-create-system v1.0
