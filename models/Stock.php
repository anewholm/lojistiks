<?php

namespace AcornAssociated\Lojistiks\Models;

use AcornAssociated\Model;

/**
 * Stock Model
 */
class Stock extends Model
{
    use \Winter\Storm\Database\Traits\Validation;

    /**
     * @var string The database table used by the model.
     */
    public $table = 'acornassociated_lojistiks_stocks';

    /**
     * @var array Guarded fields
     */
    protected $guarded = ['*'];

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
    public $hasMany = [];
    public $hasOneThrough = [];
    public $hasManyThrough = [];
    public $belongsTo = [
        'product_instance' => ProductInstance::class,
        'location' => Location::class,
    ];
    public $belongsToMany = [];
    public $morphTo = [];
    public $morphOne = [];
    public $morphMany = [];
    public $attachOne = [];
    public $attachMany = [];

    public function getFullyQualifiedNameAttribute()
    {
        $piName       = $this->product_instance->name();
        $locationName = $this->location->fullyQualifiedName();
        return "$piName @ $locationName x $this->quantity";
    }

    public function fullyQualifiedName()
    {
        return $this->fully_qualified_name;
    }

    public static function menuitemCount()
    {
        return self::all()->count();
    }
}