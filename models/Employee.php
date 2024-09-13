<?php

namespace Acorn\Lojistiks\Models;

use Model;
use Backend\Models\UserRole;

/**
 * Employee Model
 */
class Employee extends Model
{
    use \Winter\Storm\Database\Traits\Validation;

    /**
     * @var string The database table used by the model.
     */
    public $table = 'acorn_lojistiks_employees';

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
    public $hasMany = [];
    public $hasOneThrough = [];
    public $hasManyThrough = [];
    public $belongsTo = [
        'person' => Person::class,
        'location' => Location::class,
        'user_role' => UserRole::class,
    ];
    public $belongsToMany = [];
    public $morphTo = [];
    public $morphOne = [];
    public $morphMany = [];
    public $attachOne = [];
    public $attachMany = [];

    public function getFullNameAttribute()
    {
        return $this->person->fullName();
    }

    public function fullName()
    {
        return $this->full_name;
    }

    public function getEmploymentAttribute()
    {
        $role = $this->user_role->name;
        $name = $this->person->fullName();
        return "$name ($role)";
    }

    public function employment()
    {
        return $this->employment;
    }

    public static function menuitemCount()
    {
        return self::all()->count();
    }
}
