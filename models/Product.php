<?php

namespace Acorn\Lojistiks\Models;

use Acorn\Model;
use System\Models\File;

/**
 * Product Model
 */
class Product extends Model
{
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
        'image' => 'nullable',
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
        'electronic_product' => ElectronicProduct::class,
    ];
    public $hasMany = [
        'product_instances' => ProductInstance::class,
    ];
    public $hasOneThrough = [
        'computer_product' => [
            ComputerProduct::class,
            'through' => ElectronicProduct::class,
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
        $leafProduct     = $this->getLeafTypeObject();
        $leafProductName = ($leafProduct ? $leafProduct->name() : $this->getShortClassName());
        $type            = ($this->type ? "($this->type)" : '');
        return "$leafProductName $type, $brandName $this->model";
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
