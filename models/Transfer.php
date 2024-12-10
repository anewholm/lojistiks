<?php

namespace Acorn\Lojistiks\Models;

use Acorn\Models\Server;
use Acorn\Collection;
use BackendAuth;
use \Backend\Models\User;
use \Backend\Models\UserGroup;
use Exception;
use Flash;


use Acorn\Model;

/**
 * Transfer Model
 */
class Transfer extends Model
{
    /* Generated Fields:
     * id(uuid)
     * location_id(uuid)
     * driver_id(uuid)
     * server_id(uuid)
     * vehicle_id(uuid)
     * created_by_user_id(uuid)
     * created_at_event_id(uuid)
     * response(text)
     * pre_marked_arrived(boolean)
     * sent_at_event_id(uuid)
     * arrived_at_event_id(uuid)
     */

    public $hasManyDeep = [];
    public $actionFunctions = [];
    use \Winter\Storm\Database\Traits\Revisionable;
    use \Illuminate\Database\Eloquent\Concerns\HasUuids;


    protected $revisionable = [];
    public $timestamps = 0;
    use \Winter\Storm\Database\Traits\Validation;

    /**
     * @var string The database table used by the model.
     */
    public $table = 'acorn_lojistiks_transfers';

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
        'location' => 'required'
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
        'criminal_defendant_detentions_transfer' => [\Acorn\Lojistiks\Models\Transfer::class, 'key' => 'transfer_id', 'type' => '1from1'],
        'criminal_defendant_detentions_actual_release_transfer' => [\Acorn\Lojistiks\Models\Transfer::class, 'key' => 'actual_release_transfer_id', 'type' => '1from1']
    ];
    public $hasMany = [
        'lojistiks_product_instance_transfer_transfers_pivot' => [\Acorn\Lojistiks\Models\ProductInstanceTransfer::class, 'key' => 'transfer_id', 'otherKey' => 'product_instance_id', 'type' => 'XfromXSemi'],
        'lojistiks_transfer_invoice_transfers_pivot' => [\Acorn\Lojistiks\Models\TransferInvoice::class, 'key' => 'transfer_id', 'otherKey' => 'invoice_id', 'type' => 'XfromXSemi'],
        'lojistiks_transfer_purchase_transfers_pivot' => [\Acorn\Lojistiks\Models\TransferPurchase::class, 'key' => 'transfer_id', 'otherKey' => 'purchase_id', 'type' => 'XfromXSemi']
    ];
    public $hasOneThrough = [];
    public $hasManyThrough = [];
    public $belongsTo = [
        'location' => [\Acorn\Location\Models\Location::class, 'key' => 'location_id', 'name' => FALSE, 'type' => 'Xto1'],
        'driver' => [\Acorn\Lojistiks\Models\Driver::class, 'key' => 'driver_id', 'name' => FALSE, 'type' => 'Xto1'],
        'server' => [\Acorn\Models\Server::class, 'key' => 'server_id', 'name' => FALSE, 'type' => 'Xto1'],
        'vehicle' => [\Acorn\Lojistiks\Models\Vehicle::class, 'key' => 'vehicle_id', 'name' => FALSE, 'type' => 'Xto1'],
        'created_by_user' => [\Acorn\User\Models\User::class, 'key' => 'created_by_user_id', 'name' => FALSE, 'type' => 'Xto1'],
        'created_at_event' => [\Acorn\Calendar\Models\Event::class, 'key' => 'created_at_event_id', 'name' => FALSE, 'type' => 'Xto1'],
        'sent_at_event' => [\Acorn\Calendar\Models\Event::class, 'key' => 'sent_at_event_id', 'name' => FALSE, 'type' => 'Xto1'],
        'arrived_at_event' => [\Acorn\Calendar\Models\Event::class, 'key' => 'arrived_at_event_id', 'name' => FALSE, 'type' => 'Xto1']
    ];
    public $belongsToMany = [
        'lojistiks_product_instance_transfer_transfers' => [\Acorn\Lojistiks\Models\ProductInstance::class, 'table' => 'acorn_lojistiks_product_instance_transfer', 'key' => 'transfer_id', 'otherKey' => 'product_instance_id', 'type' => 'XfromXSemi'],
        'lojistiks_transfer_invoice_transfers' => [\Acorn\Finance\Models\Invoice::class, 'table' => 'acorn_lojistiks_transfer_invoice', 'key' => 'transfer_id', 'otherKey' => 'invoice_id', 'type' => 'XfromXSemi'],
        'lojistiks_transfer_purchase_transfers' => [\Acorn\Finance\Models\Purchase::class, 'table' => 'acorn_lojistiks_transfer_purchase', 'key' => 'transfer_id', 'otherKey' => 'purchase_id', 'type' => 'XfromXSemi']
    ];
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
