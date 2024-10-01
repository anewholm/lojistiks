<?php

namespace Acorn\Lojistiks\Models;

use Acorn\Model;
use Acorn\Models\Server;
use System\Models\File;
use Acorn\Collection;

/**
 * Product Model
 */
class Product extends Model
{
    use \Winter\Storm\Database\Traits\Validation;

    public $translatable = ['name', 'model_name'];

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
        'image' => 'nullable',
        'brand' => 'required',
        'measurement_unit' => 'required',
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
        'electronic_product' => [ElectronicProduct::class, 'leaf' => TRUE],
    ];
    public $hasMany = [
        'product_instances' => ProductInstance::class,
    ];
    public $hasOneThrough = [
        'computer_product' => [
            ComputerProduct::class,
            'through' => ElectronicProduct::class,
            'leaf' => TRUE,
        ],
    ];
    public $hasManyThrough = [];
    public $belongsTo = [
        'measurement_unit' => MeasurementUnit::class,
        'brand' => Brand::class,
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

    public function getUsesQuantityAttribute()
    {
        $this->load('measurement_unit');
        return (bool) $this->measurement_unit?->usesQuantity();
    }

    public function usesQuantity()
    {
        return $this->uses_quantity;
    }

    public function qrCodeName()
    {
        return $this->qr_code_name;
    }

    public function getQrCodeNameAttribute()
    {
        return $this->fullName();
    }

    public function getFullNameAttribute()
    {
        $this->load('brand');
        $isRecordContext = is_string($this->brand);
        $brandName       = ($isRecordContext ? $this->brand : $this->brand?->name());
        $leafProduct     = $this->getLeafTypeModel(); // ComputerProduct
        $name            = ($leafProduct && method_exists($leafProduct, 'name') ? $leafProduct->name() : $this->name);

        // Rendering
        $nameString      = ($name ? "$name, " : '');
        $type            = ($this->leaf_type  ? " ($this->leaf_type)" : '');
        $modelName       = ($this->model_name ? " $this->model_name"  : '');

        return "$nameString$brandName$modelName$type";
    }

    public function fullName()
    {
        return $this->full_name;
    }

    public function createInstance(string $assetClass = 'C')
    {
        return $this->createInstances(1, $assetClass);
    }

    public function createInstances(float $quantity, string $assetClass = 'C')
    {
        $pis = new Collection();

        if ($this->usesQuantity()) {
            $pis->push(ProductInstance::create(['product' => $this, 'asset_class' => $assetClass, 'quantity' => $quantity]));
        } else {
            for ($i = 0; $i < $quantity; $i++) {
                $pis->push(ProductInstance::create(['product' => $this, 'asset_class' => $assetClass, 'quantity' => 1]));
            }
        }
        return $pis;
    }

    public static function menuitemCount()
    {
        return self::all()->count();
    }

    public function filterFields($fields, $context = NULL)
    {
        // Set default for electronic_product[product][measurement_unit]
        // Because we are using UUIDs
        $fieldName            = 'measurement_unit';
        $measurementUnitValue = &$fields->$fieldName->value;
        if (is_null($measurementUnitValue)) {
            if ($units = MeasurementUnit::where('name', 'Units')->first()) {
                $measurementUnitValue = $units->id();
            }
        }
    }
}
