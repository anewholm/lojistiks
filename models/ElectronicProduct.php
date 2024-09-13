<?php

namespace Acorn\Lojistiks\Models;

use Acorn\Model;
use Acorn\Models\Server;
use System\Models\File;

/**
 * ElectronicProduct Model
 */
class ElectronicProduct extends Model
{
    use \Winter\Storm\Database\Traits\Validation;

    /**
     * @var string The database table used by the model.
     */
    public $table = 'product.acorn_lojistiks_electronic_products';

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
        'product_instances' => ProductInstance::class,
    ];
    public $hasOneThrough = [];
    public $hasManyThrough = [];
    public $belongsTo = [
        'product' => Product::class,
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

    public function name()
    {
        $this->load('product');
        return $this->product->name();
    }

    public static function menuitemCount()
    {
        return self::all()->count();
    }

    public function filterFields($fields, $context = NULL)
    {
        // Set default for electronic_product[product][measurement_unit]
        // Because we are using UUIDs
        $fieldName = 'product[measurement_unit]';
        $measurementUnitValue = &$fields->$fieldName->value;
        if (is_null($measurementUnitValue)) {
            if ($units = MeasurementUnit::where('name', 'Units')->first()) {
                $measurementUnitValue = $units->id();
            }
        }
    }
}
