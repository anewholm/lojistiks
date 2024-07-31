<?php

namespace AcornAssociated\Lojistiks\Models;

use AcornAssociated\Lojistiks\Classes\QRCodeModel;
use Flash;
use Illuminate\Database\Eloquent\Collection;

/**
 * Transfer Model
 */
class Transfer extends QRCodeModel
{
    use \Winter\Storm\Database\Traits\Validation;

    /**
     * @var string The database table used by the model.
     */
    public $table = 'acornassociated_lojistiks_transfers';

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
        'transfer_product_instances' => TransferProductInstance::class,
        'vehicles' => Vehicle::class,
    ];
    public $hasOneThrough = [];
    public $hasManyThrough = [
        'product_instances' => [
            ProductInstance::class,
            'through' => TransferProductInstance::class,
        ],
    ];
    public $belongsTo = [
        'source_location' => Location::class,
        'destination_location' => Location::class,
        'vehicle' => Vehicle::class,
        'server' => Server::class,
    ];
    public $belongsToMany = [];
    public $morphTo = [];
    public $morphOne = [];
    public $morphMany = [];
    public $attachOne = [];
    public $attachMany = [];

    public function getDestinationNameAttribute()
    {
        $this->load('destination_location');
        return $this->destination_location->fullyQualifiedName();
    }

    public function getSourceNameAttribute()
    {
        $this->load('source_location');
        return $this->source_location->fullyQualifiedName();
    }

    public function getFullNameAttribute()
    {
        return "$this->source_name => $this->destination_name";
    }

    public function fullName()
    {
        return $this->full_name;
    }

    public function setProductInstance(ProductInstance $pi)
    {
        $this->setProductInstances(new Collection([$pi]));
    }

    public function setProductInstances(Collection $pis)
    {
        $tpis = new Collection();
        foreach ($pis as $pi) $tpis->push(TransferProductInstance::create(['transfer' => $this, 'product_instance' => $pi]));
        $this->transfer_product_instances = $tpis;
    }

    public function singleTransferProductInstance()
    {
        if (count($this->transfer_product_instances) != 1) throw new Exception('Transfer was not singular');
        return $this->transfer_product_instances[0];
    }

    public static function menuitemCount()
    {
        return self::all()->count();
    }
}
