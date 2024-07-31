<?php

namespace Acorn\Lojistiks\Models;

use Acorn\Model;
use Illuminate\Database\Eloquent\Collection;

/**
 * ProductInstance Model
 */
class ProductInstance extends Model
{
    use \Winter\Storm\Database\Traits\Validation;

    /**
     * @var string The database table used by the model.
     */
    public $table = 'acorn_lojistiks_product_instances';

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
    public $hasMany = [
        'transfer_product_instances' => TransferProductInstance::class,
    ];
    public $hasOneThrough = [];
    public $hasManyThrough = [];
    public $belongsTo = [
        'product'  => Product::class,
        'server' => Server::class,
        'initial_transfer_product_instance' => [TransferProductInstance::class, 'key' => 'initial_transfer_product_instance_id'],
    ];
    public $belongsToMany = [];
    public $morphTo = [];
    public $morphOne = [];
    public $morphMany = [];
    public $attachOne = [];
    public $attachMany = [];

    public function name()
    {
        return $this->product->name . " ($this->external_identifier)" . ($this->quantity == 1 ? '' : " x $this->quantity");
    }

    public function afterCreate()
    {
        // Create the initial transfer to indicate where the PI is
        $source_location      = Location::findOrFail($this->getOriginalPurgeValue('_source_location'));
        $destination_location = Location::findOrFail($this->getOriginalPurgeValue('_destination_location'));
        $tr = Transfer::create([
            'source_location'      => $source_location,
            'destination_location' => $destination_location
        ]);
        $tr->setProductInstance($this);
        $tr->save();

        // Store result
        $this->initial_transfer_product_instance = $tr->singleTransferProductInstance();
        $this->save();
    }

    public static function menuitemCount()
    {
        return self::all()->count();
    }
}
