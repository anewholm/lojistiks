<?php

namespace AcornAssociated\Lojistiks\Models;

use AcornAssociated\Models\Server;
use AcornAssociated\Collection;
use BackendAuth;
use \Backend\Models\User;
use \Backend\Models\UserGroup;
use Exception;
use Flash;


use AcornAssociated\Model;

/**
 * ElectronicProduct Model
 */
class ElectronicProduct extends Model
{
    /* Generated Fields:
     * id(uuid)
     * product_id(uuid)
     * server_id(uuid)
     * created_at_event_id(uuid)
     * voltage(double precision)
     * created_by_user_id(uuid)
     * response(text)
     */

    public $hasManyDeep = [
        'product_lojistiks_product_instances_product' => [\AcornAssociated\Lojistiks\Models\ProductInstance::class, 'throughRelations' => ['product', 'lojistiks_product_instances_product']],
        'product_lojistiks_product_products_product' => [\AcornAssociated\Lojistiks\Models\ProductProduct::class, 'throughRelations' => ['product', 'lojistiks_product_products_product']],
        'product_lojistiks_product_attributes_product' => [\AcornAssociated\Lojistiks\Models\ProductAttribute::class, 'throughRelations' => ['product', 'lojistiks_product_attributes_product']],
        'product_lojistiks_product_products_sub_product' => [\AcornAssociated\Lojistiks\Models\ProductProduct::class, 'throughRelations' => ['product', 'lojistiks_product_products_sub_product']],
        'product_lojistiks_products_product_category_products' => [\AcornAssociated\Lojistiks\Models\ProductCategory::class, 'throughRelations' => ['product', 'lojistiks_products_product_category_products']],
        'product_lojistiks_product_product_category_products' => [\AcornAssociated\Lojistiks\Models\ProductCategory::class, 'throughRelations' => ['product', 'lojistiks_product_product_category_products']]
    ];
    public $actionFunctions = [];
    use \Winter\Storm\Database\Traits\Revisionable;
    use \Illuminate\Database\Eloquent\Concerns\HasUuids;


    protected $revisionable = [];
    public $timestamps = 0;
    use \Winter\Storm\Database\Traits\Validation;

    /**
     * @var string The database table used by the model.
     */
    public $table = 'product.acornassociated_lojistiks_electronic_products';

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
        'product' => 'required'
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
    public $hasOne = [
        'lojistiks_computer_products_electronic_product' => [\AcornAssociated\Lojistiks\Models\ComputerProduct::class, 'key' => 'electronic_product_id', 'type' => '1from1']
    ];
    public $hasMany = [];
    public $hasOneThrough = [];
    public $hasManyThrough = [];
    public $belongsTo = [
        'product' => [\AcornAssociated\Lojistiks\Models\Product::class, 'key' => 'product_id', 'name' => TRUE, 'type' => '1to1'],
        'server' => [\AcornAssociated\Models\Server::class, 'key' => 'server_id', 'type' => 'Xto1'],
        'created_at_event' => [\AcornAssociated\Calendar\Models\Event::class, 'key' => 'created_at_event_id', 'type' => 'Xto1'],
        'created_by_user' => [\AcornAssociated\User\Models\User::class, 'key' => 'created_by_user_id', 'type' => 'Xto1']
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
