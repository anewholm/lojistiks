<?php

namespace Acorn\Lojistiks\Models;

use Acorn\Model;
use Acorn\Models\Server;
use Acorn\User\Models\User;
use System\Models\File;
use BackendAuth;
use Str;

/**
 * Person Model
 */
class Person extends Model
{
    use \Winter\Storm\Database\Traits\Validation;

    /**
     * @var string The database table used by the model.
     */
    public $table = 'acorn_lojistiks_people';

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
        'user' => User::class,
        'server' => Server::class,
        // Lasts: see below
        'last_transfer_source_location' => Location::class,
        'last_transfer_destination_location' => Location::class,
        'last_product_instance_source_location' => Location::class,
        'last_product_instance_destination_location' => Location::class,
    ];
    public $belongsToMany = [];
    public $morphTo = [];
    public $morphOne = [];
    public $morphMany = [];
    public $attachOne = [
        'image' => File::class,
    ];
    public $attachMany = [];

    public function getFullNameAttribute()
    {
        $this->load('user');
        return $this->user->name;
    }

    public function fullName()
    {
        return $this->full_name;
    }

    public static function menuitemCount()
    {
        return self::all()->count();
    }

    public static function auth()
    {
        // Any front-end user associated with this backend account
        // This is usually through a user_id to the User plugin
        $user = BackendAuth::user();
        # TODO: Temporary HACK: to assign lasts. This needs to be moved in to acorn_user_users with a user_id link from backend_users
        return ($user ? Person::all()->first() : NULL);
    }

    public static function saveLastsToAuthPerson(Array $lastModels, Model $sectionModel = NULL): void
    {
        if ($person = Person::auth()) $person->saveLasts($lastModels, $sectionModel);
    }

    public function saveLasts(Array $lastModels, Model $sectionModel = NULL): void
    {
        $sectionModelName = ($sectionModel ? Str::snake($sectionModel->unqualifiedClassName()) : '');
        $attributePrefix  = "last_$sectionModelName" . ($sectionModelName ? '_' : '');
        foreach ($lastModels as $name => $model) {
            $attributeName        = "$attributePrefix$name";
            $this->$attributeName = $model;
        }
        $this->save();
    }

    public static function lastsFromAuthPersonFor(Model $sectionModel): array
    {
        $person = Person::auth();
        return ($person ? $person->lastsFor($sectionModel) : []);
    }

    public function lastsFor(Model $sectionModel): array
    {
        // TODO: Move this up in to User plugin
        $lasts = array();
        $sectionModelName   = ($sectionModel ? Str::snake($sectionModel->unqualifiedClassName()) : '');
        $attributePrefix    = "last_$sectionModelName" . ($sectionModelName ? '_' : '');
        $attributePrefixLen = strlen($attributePrefix);
        $this->load(array_keys($this->belongsTo));
        foreach ($this->relations as $name => $model) {
            if ($model && substr($name, 0, $attributePrefixLen) == $attributePrefix) {
                $attributeName = substr($name, $attributePrefixLen);
                $pseudoName    = "_$attributeName";
                $lasts[$attributeName] = $model;
                $lasts[$pseudoName]    = $model;
            }
        }
        return $lasts;
    }
}
