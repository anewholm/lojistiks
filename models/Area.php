<?php

namespace Acorn\Lojistiks\Models;

use Acorn\Model;
use Acorn\Models\Server;
use Acorn\Collection;

/**
 * Area Model
 */
class Area extends Model
{
    use \Winter\Storm\Database\Traits\Validation;

    /**
     * @var string The database table used by the model.
     */
    public $table = 'acorn_lojistiks_areas';

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
        // TODO: acorn-create-system should implant these
        'children' => [Area::class,    'key' => 'parent_area_id'],
        'address'  => [Address::class, 'key' => 'area_id'],
    ];
    public $hasOneThrough = [];
    public $hasManyThrough = [];
    public $belongsTo = [
        'parent' => [Area::class, 'key' => 'parent_area_id'],
        'area_type' => AreaType::class,
        'gps' => GPS::class,
        'server' => server::class,
    ];
    public $belongsToMany = [];
    public $morphTo = [];
    public $morphOne = [];
    public $morphMany = [];
    public $attachOne = [];
    public $attachMany = [];

    protected function getFullyQualifiedNameAttribute()
    {
        $this->load('parent');
        $parentAreaFQName = ($this->parent ? $this->parent->fullyQualifiedName() . '/' : '');
        return "$parentAreaFQName$this->name";
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
