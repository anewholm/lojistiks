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
 * Product Model
 */
class Product extends Model
{
    /* Generated Fields:
     * id(uuid)
     * name(character varying)
     * measurement_unit_id(uuid)
     * brand_id(uuid)
     * model_name(character varying)
     * server_id(uuid)
     * created_at_event_id(uuid)
     * created_by_user_id(uuid)
     * response(text)
     * image(path)
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
    public $table = 'acorn_lojistiks_products';

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
        'measurement_unit' => 'required',
        'brand' => 'required'
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
        'lojistiks_electronic_products_product' => [\Acorn\Lojistiks\Models\ElectronicProduct::class, 'key' => 'product_id', 'type' => '1fromX'],
        'lojistiks_products_product_categories_product' => [\Acorn\Lojistiks\Models\ProductsProductCategory::class, 'key' => 'product_id', 'type' => '1fromX'],
        'lojistiks_product_instances_product' => [\Acorn\Lojistiks\Models\ProductInstance::class, 'key' => 'product_id', 'type' => '1fromX'],
        'lojistiks_product_products_product' => [\Acorn\Lojistiks\Models\ProductProduct::class, 'key' => 'product_id', 'type' => '1fromX'],
        'lojistiks_product_attributes_product' => [\Acorn\Lojistiks\Models\ProductAttribute::class, 'key' => 'product_id', 'type' => '1fromX'],
        'lojistiks_product_products_sub_product' => [\Acorn\Lojistiks\Models\ProductProduct::class, 'key' => 'sub_product_id', 'type' => '1fromX']
    ];
    public $hasOneThrough = [];
    public $hasManyThrough = [];
    public $belongsTo = [
        'measurement_unit' => [\Acorn\Lojistiks\Models\MeasurementUnit::class, 'key' => 'measurement_unit_id', 'name' => FALSE, 'type' => 'Xto1'],
        'brand' => [\Acorn\Lojistiks\Models\Brand::class, 'key' => 'brand_id', 'name' => FALSE, 'type' => 'Xto1'],
        'server' => [\Acorn\Models\Server::class, 'key' => 'server_id', 'name' => FALSE, 'type' => 'Xto1'],
        'created_at_event' => [\Acorn\Calendar\Models\Event::class, 'key' => 'created_at_event_id', 'name' => FALSE, 'type' => 'Xto1'],
        'created_by_user' => [\Acorn\User\Models\User::class, 'key' => 'created_by_user_id', 'name' => FALSE, 'type' => 'Xto1']
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
}
// Created By acorn-create-system v1.0
