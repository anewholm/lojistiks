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
 * ProductCategory Model
 */
class ProductCategory extends Model
{
    /* Generated Fields:
     * id(uuid)
     * name(character varying)
     * product_category_type_id(uuid)
     * parent_product_category_id(uuid)
     * server_id(uuid)
     * created_at_event_id(uuid)
     * created_by_user_id(uuid)
     * response(text)
     * description(text)
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
    public $table = 'acorn_lojistiks_product_categories';

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
        'product_category_type' => 'required',
        'parent_product_category' => 'required'
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
        'lojistiks_products_product_categories_product_category' => [\Acorn\Lojistiks\Models\ProductsProductCategory::class, 'key' => 'product_category_id', 'type' => '1fromX'],
        'children' => [\Acorn\Lojistiks\Models\ProductCategory::class, 'key' => 'parent_product_category_id', 'type' => 'Self']
    ];
    public $hasOneThrough = [];
    public $hasManyThrough = [];
    public $belongsTo = [
        'product_category_type' => [\Acorn\Lojistiks\Models\ProductCategoryType::class, 'key' => 'product_category_type_id', 'name' => FALSE, 'type' => 'Xto1'],
        'server' => [\Acorn\Models\Server::class, 'key' => 'server_id', 'name' => FALSE, 'type' => 'Xto1'],
        'created_at_event' => [\Acorn\Calendar\Models\Event::class, 'key' => 'created_at_event_id', 'name' => FALSE, 'type' => 'Xto1'],
        'created_by_user' => [\Acorn\User\Models\User::class, 'key' => 'created_by_user_id', 'name' => FALSE, 'type' => 'Xto1'],
        'parent_product_category' => [\Acorn\Lojistiks\Models\ProductCategory::class, 'key' => 'parent_product_category_id', 'type' => 'Self'],
        'parent' => [\Acorn\Lojistiks\Models\ProductCategory::class, 'key' => 'parent_product_category_id', 'type' => 'Self']
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
