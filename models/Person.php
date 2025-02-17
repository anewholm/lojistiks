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
 * Person Model
 */
class Person extends Model
{
    /* Generated Fields:
     * id(uuid)
     * user_id(uuid)
     * image(character varying)
     * server_id(uuid)
     * created_at_event_id(uuid)
     * created_by_user_id(uuid)
     * response(text)
     * last_transfer_location_id(uuid)
     * last_product_instance_location_id(uuid)
     * description(text)
     */

    public $hasManyDeep = [
        'user_lojistiks_computer_products_created_by_user' => [\Acorn\Lojistiks\Models\ComputerProduct::class, 'throughRelations' => ['user', 'lojistiks_computer_products_created_by_user']],
        'user_lojistiks_electronic_products_created_by_user' => [\Acorn\Lojistiks\Models\ElectronicProduct::class, 'throughRelations' => ['user', 'lojistiks_electronic_products_created_by_user']],
        'user_calendar_events_owner_user' => [\Acorn\Calendar\Models\Event::class, 'throughRelations' => ['user', 'calendar_events_owner_user']],
        'user_calendar_event_part_user_user' => [\Acorn\Calendar\Models\EventPartUser::class, 'throughRelations' => ['user', 'calendar_event_part_user_user']],
        'user_calendar_calendars_owner_user' => [\Acorn\Calendar\Models\Calendar::class, 'throughRelations' => ['user', 'calendar_calendars_owner_user']],
        'user_messaging_user_message_status_user' => [\Acorn\Messaging\Models\UserMessageStatus::class, 'throughRelations' => ['user', 'messaging_user_message_status_user']],
        'user_location_addresses_created_by_user' => [\Acorn\Location\Models\Address::class, 'throughRelations' => ['user', 'location_addresses_created_by_user']],
        'user_location_area_types_created_by_user' => [\Acorn\Location\Models\AreaType::class, 'throughRelations' => ['user', 'location_area_types_created_by_user']],
        'user_location_areas_created_by_user' => [\Acorn\Location\Models\Area::class, 'throughRelations' => ['user', 'location_areas_created_by_user']],
        'user_lojistiks_brands_created_by_user' => [\Acorn\Lojistiks\Models\Brand::class, 'throughRelations' => ['user', 'lojistiks_brands_created_by_user']],
        'user_lojistiks_containers_created_by_user' => [\Acorn\Lojistiks\Models\Container::class, 'throughRelations' => ['user', 'lojistiks_containers_created_by_user']],
        'user_lojistiks_product_instance_transfer_created_by_user' => [\Acorn\Lojistiks\Models\ProductInstanceTransfer::class, 'throughRelations' => ['user', 'lojistiks_product_instance_transfer_created_by_user']],
        'user_justice_legalcases_created_by_user' => [\Acorn\Justice\Models\Legalcase::class, 'throughRelations' => ['user', 'justice_legalcases_created_by_user']],
        'user_justice_legalcase_identifiers_created_by_user' => [\Acorn\Justice\Models\LegalcaseIdentifier::class, 'throughRelations' => ['user', 'justice_legalcase_identifiers_created_by_user']],
        'user_criminal_crime_sentences_created_by_user' => [\Acorn\Criminal\Models\CrimeSentence::class, 'throughRelations' => ['user', 'criminal_crime_sentences_created_by_user']],
        'user_criminal_trial_judges_created_by_user' => [\Acorn\Criminal\Models\TrialJudge::class, 'throughRelations' => ['user', 'criminal_trial_judges_created_by_user']],
        'user_criminal_sentence_types_created_by_user' => [\Acorn\Criminal\Models\SentenceType::class, 'throughRelations' => ['user', 'criminal_sentence_types_created_by_user']],
        'user_criminal_legalcase_plaintiffs_created_by_user' => [\Acorn\Criminal\Models\LegalcasePlaintiff::class, 'throughRelations' => ['user', 'criminal_legalcase_plaintiffs_created_by_user']],
        'user_criminal_legalcase_evidence_created_by_user' => [\Acorn\Criminal\Models\LegalcaseEvidence::class, 'throughRelations' => ['user', 'criminal_legalcase_evidence_created_by_user']],
        'user_criminal_crimes_created_by_user' => [\Acorn\Criminal\Models\Crime::class, 'throughRelations' => ['user', 'criminal_crimes_created_by_user']],
        'user_criminal_crime_types_created_by_user' => [\Acorn\Criminal\Models\CrimeType::class, 'throughRelations' => ['user', 'criminal_crime_types_created_by_user']],
        'user_criminal_defendant_crimes_created_by_user' => [\Acorn\Criminal\Models\DefendantCrime::class, 'throughRelations' => ['user', 'criminal_defendant_crimes_created_by_user']],
        'user_criminal_appeals_created_by_user' => [\Acorn\Criminal\Models\Appeal::class, 'throughRelations' => ['user', 'criminal_appeals_created_by_user']],
        'user_criminal_legalcase_defendants_created_by_user' => [\Acorn\Criminal\Models\LegalcaseDefendant::class, 'throughRelations' => ['user', 'criminal_legalcase_defendants_created_by_user']],
        'user_criminal_legalcase_prosecutor_created_by_user' => [\Acorn\Criminal\Models\LegalcaseProsecutor::class, 'throughRelations' => ['user', 'criminal_legalcase_prosecutor_created_by_user']],
        'user_criminal_legalcase_witnesses_created_by_user' => [\Acorn\Criminal\Models\LegalcaseWitness::class, 'throughRelations' => ['user', 'criminal_legalcase_witnesses_created_by_user']],
        'user_criminal_trial_sessions_created_by_user' => [\Acorn\Criminal\Models\TrialSession::class, 'throughRelations' => ['user', 'criminal_trial_sessions_created_by_user']],
        'user_criminal_trials_created_by_user' => [\Acorn\Criminal\Models\Trial::class, 'throughRelations' => ['user', 'criminal_trials_created_by_user']],
        'user_criminal_session_recordings_created_by_user' => [\Acorn\Criminal\Models\SessionRecording::class, 'throughRelations' => ['user', 'criminal_session_recordings_created_by_user']],
        'user_justice_scanned_documents_created_by_user' => [\Acorn\Justice\Models\ScannedDocument::class, 'throughRelations' => ['user', 'justice_scanned_documents_created_by_user']],
        'user_justice_warrants_created_by_user' => [\Acorn\Justice\Models\Warrant::class, 'throughRelations' => ['user', 'justice_warrants_created_by_user']],
        'user_lojistiks_drivers_created_by_user' => [\Acorn\Lojistiks\Models\Driver::class, 'throughRelations' => ['user', 'lojistiks_drivers_created_by_user']],
        'user_lojistiks_employees_created_by_user' => [\Acorn\Lojistiks\Models\Employee::class, 'throughRelations' => ['user', 'lojistiks_employees_created_by_user']],
        'user_location_gps_created_by_user' => [\Acorn\Location\Models\Gps::class, 'throughRelations' => ['user', 'location_gps_created_by_user']],
        'user_location_locations_created_by_user' => [\Acorn\Location\Models\Location::class, 'throughRelations' => ['user', 'location_locations_created_by_user']],
        'user_lojistiks_measurement_units_created_by_user' => [\Acorn\Lojistiks\Models\MeasurementUnit::class, 'throughRelations' => ['user', 'lojistiks_measurement_units_created_by_user']],
        'user_lojistiks_offices_created_by_user' => [\Acorn\Lojistiks\Models\Office::class, 'throughRelations' => ['user', 'lojistiks_offices_created_by_user']],
        'user_finance_invoices_payee_user' => [\Acorn\Finance\Models\Invoice::class, 'throughRelations' => ['user', 'finance_invoices_payee_user']],
        'user_finance_purchases_payee_user' => [\Acorn\Finance\Models\Purchase::class, 'throughRelations' => ['user', 'finance_purchases_payee_user']],
        'user_finance_purchases_payer_user' => [\Acorn\Finance\Models\Purchase::class, 'throughRelations' => ['user', 'finance_purchases_payer_user']],
        'user_finance_invoices_payer_user' => [\Acorn\Finance\Models\Invoice::class, 'throughRelations' => ['user', 'finance_invoices_payer_user']],
        'user_lojistiks_people_created_by_user' => [\Acorn\Lojistiks\Models\Person::class, 'throughRelations' => ['user', 'lojistiks_people_created_by_user']],
        'user_lojistiks_product_attributes_created_by_user' => [\Acorn\Lojistiks\Models\ProductAttribute::class, 'throughRelations' => ['user', 'lojistiks_product_attributes_created_by_user']],
        'user_lojistiks_product_categories_created_by_user' => [\Acorn\Lojistiks\Models\ProductCategory::class, 'throughRelations' => ['user', 'lojistiks_product_categories_created_by_user']],
        'user_lojistiks_product_category_types_created_by_user' => [\Acorn\Lojistiks\Models\ProductCategoryType::class, 'throughRelations' => ['user', 'lojistiks_product_category_types_created_by_user']],
        'user_lojistiks_product_instances_created_by_user' => [\Acorn\Lojistiks\Models\ProductInstance::class, 'throughRelations' => ['user', 'lojistiks_product_instances_created_by_user']],
        'user_lojistiks_product_products_created_by_user' => [\Acorn\Lojistiks\Models\ProductProduct::class, 'throughRelations' => ['user', 'lojistiks_product_products_created_by_user']],
        'user_lojistiks_products_created_by_user' => [\Acorn\Lojistiks\Models\Product::class, 'throughRelations' => ['user', 'lojistiks_products_created_by_user']],
        'user_lojistiks_products_product_category_created_by_user' => [\Acorn\Lojistiks\Models\ProductsProductCategory::class, 'throughRelations' => ['user', 'lojistiks_products_product_category_created_by_user']],
        'user_lojistiks_suppliers_created_by_user' => [\Acorn\Lojistiks\Models\Supplier::class, 'throughRelations' => ['user', 'lojistiks_suppliers_created_by_user']],
        'user_lojistiks_transfers_created_by_user' => [\Acorn\Lojistiks\Models\Transfer::class, 'throughRelations' => ['user', 'lojistiks_transfers_created_by_user']],
        'user_location_types_created_by_user' => [\Acorn\Location\Models\Type::class, 'throughRelations' => ['user', 'location_types_created_by_user']],
        'user_criminal_legalcase_defendants_user' => [\Acorn\Criminal\Models\LegalcaseDefendant::class, 'throughRelations' => ['user', 'criminal_legalcase_defendants_user']],
        'user_criminal_legalcase_plaintiffs_user' => [\Acorn\Criminal\Models\LegalcasePlaintiff::class, 'throughRelations' => ['user', 'criminal_legalcase_plaintiffs_user']],
        'user_criminal_legalcase_witnesses_user' => [\Acorn\Criminal\Models\LegalcaseWitness::class, 'throughRelations' => ['user', 'criminal_legalcase_witnesses_user']],
        'user_criminal_trial_judges_user' => [\Acorn\Criminal\Models\TrialJudge::class, 'throughRelations' => ['user', 'criminal_trial_judges_user']],
        'user_justice_warrants_user' => [\Acorn\Justice\Models\Warrant::class, 'throughRelations' => ['user', 'justice_warrants_user']],
        'user_lojistiks_vehicle_types_created_by_user' => [\Acorn\Lojistiks\Models\VehicleType::class, 'throughRelations' => ['user', 'lojistiks_vehicle_types_created_by_user']],
        'user_lojistiks_vehicles_created_by_user' => [\Acorn\Lojistiks\Models\Vehicle::class, 'throughRelations' => ['user', 'lojistiks_vehicles_created_by_user']],
        'user_lojistiks_warehouses_created_by_user' => [\Acorn\Lojistiks\Models\Warehouse::class, 'throughRelations' => ['user', 'lojistiks_warehouses_created_by_user']],
        'user_criminal_legalcase_related_events_created_by_user' => [\Acorn\Criminal\Models\LegalcaseRelatedEvent::class, 'throughRelations' => ['user', 'criminal_legalcase_related_events_created_by_user']],
        'user_justice_legalcases_updated_by_user' => [\Acorn\Justice\Models\Legalcase::class, 'throughRelations' => ['user', 'justice_legalcases_updated_by_user']],
        'user_criminal_legalcase_plaintiffs_updated_by_user' => [\Acorn\Criminal\Models\LegalcasePlaintiff::class, 'throughRelations' => ['user', 'criminal_legalcase_plaintiffs_updated_by_user']],
        'user_criminal_legalcase_evidence_updated_by_user' => [\Acorn\Criminal\Models\LegalcaseEvidence::class, 'throughRelations' => ['user', 'criminal_legalcase_evidence_updated_by_user']],
        'user_criminal_legalcase_witnesses_updated_by_user' => [\Acorn\Criminal\Models\LegalcaseWitness::class, 'throughRelations' => ['user', 'criminal_legalcase_witnesses_updated_by_user']],
        'user_criminal_legalcase_defendants_updated_by_user' => [\Acorn\Criminal\Models\LegalcaseDefendant::class, 'throughRelations' => ['user', 'criminal_legalcase_defendants_updated_by_user']],
        'user_criminal_trial_judges_updated_by_user' => [\Acorn\Criminal\Models\TrialJudge::class, 'throughRelations' => ['user', 'criminal_trial_judges_updated_by_user']],
        'user_criminal_session_recordings_updated_by_user' => [\Acorn\Criminal\Models\SessionRecording::class, 'throughRelations' => ['user', 'criminal_session_recordings_updated_by_user']],
        'user_criminal_crimes_updated_by_user' => [\Acorn\Criminal\Models\Crime::class, 'throughRelations' => ['user', 'criminal_crimes_updated_by_user']],
        'user_criminal_crime_types_updated_by_user' => [\Acorn\Criminal\Models\CrimeType::class, 'throughRelations' => ['user', 'criminal_crime_types_updated_by_user']],
        'user_criminal_crime_sentences_updated_by_user' => [\Acorn\Criminal\Models\CrimeSentence::class, 'throughRelations' => ['user', 'criminal_crime_sentences_updated_by_user']],
        'user_criminal_sentence_types_updated_by_user' => [\Acorn\Criminal\Models\SentenceType::class, 'throughRelations' => ['user', 'criminal_sentence_types_updated_by_user']],
        'user_lojistiks_employees_updated_by_user' => [\Acorn\Lojistiks\Models\Employee::class, 'throughRelations' => ['user', 'lojistiks_employees_updated_by_user']],
        'user_lojistiks_offices_updated_by_user' => [\Acorn\Lojistiks\Models\Office::class, 'throughRelations' => ['user', 'lojistiks_offices_updated_by_user']],
        'user_lojistiks_measurement_units_updated_by_user' => [\Acorn\Lojistiks\Models\MeasurementUnit::class, 'throughRelations' => ['user', 'lojistiks_measurement_units_updated_by_user']],
        'user_finance_purchases_created_by_user' => [\Acorn\Finance\Models\Purchase::class, 'throughRelations' => ['user', 'finance_purchases_created_by_user']],
        'user_finance_purchases_updated_by_user' => [\Acorn\Finance\Models\Purchase::class, 'throughRelations' => ['user', 'finance_purchases_updated_by_user']],
        'user_lojistiks_product_categories_updated_by_user' => [\Acorn\Lojistiks\Models\ProductCategory::class, 'throughRelations' => ['user', 'lojistiks_product_categories_updated_by_user']],
        'user_lojistiks_product_category_types_updated_by_user' => [\Acorn\Lojistiks\Models\ProductCategoryType::class, 'throughRelations' => ['user', 'lojistiks_product_category_types_updated_by_user']],
        'user_finance_invoices_created_by_user' => [\Acorn\Finance\Models\Invoice::class, 'throughRelations' => ['user', 'finance_invoices_created_by_user']],
        'user_finance_invoices_updated_by_user' => [\Acorn\Finance\Models\Invoice::class, 'throughRelations' => ['user', 'finance_invoices_updated_by_user']],
        'user_lojistiks_product_instances_updated_by_user' => [\Acorn\Lojistiks\Models\ProductInstance::class, 'throughRelations' => ['user', 'lojistiks_product_instances_updated_by_user']],
        'user_lojistiks_product_products_updated_by_user' => [\Acorn\Lojistiks\Models\ProductProduct::class, 'throughRelations' => ['user', 'lojistiks_product_products_updated_by_user']],
        'user_lojistiks_products_updated_by_user' => [\Acorn\Lojistiks\Models\Product::class, 'throughRelations' => ['user', 'lojistiks_products_updated_by_user']],
        'user_justice_legalcase_identifiers_updated_by_user' => [\Acorn\Justice\Models\LegalcaseIdentifier::class, 'throughRelations' => ['user', 'justice_legalcase_identifiers_updated_by_user']],
        'user_lojistiks_suppliers_updated_by_user' => [\Acorn\Lojistiks\Models\Supplier::class, 'throughRelations' => ['user', 'lojistiks_suppliers_updated_by_user']],
        'user_justice_scanned_documents_updated_by_user' => [\Acorn\Justice\Models\ScannedDocument::class, 'throughRelations' => ['user', 'justice_scanned_documents_updated_by_user']],
        'user_justice_warrants_updated_by_user' => [\Acorn\Justice\Models\Warrant::class, 'throughRelations' => ['user', 'justice_warrants_updated_by_user']],
        'user_lojistiks_transfers_updated_by_user' => [\Acorn\Lojistiks\Models\Transfer::class, 'throughRelations' => ['user', 'lojistiks_transfers_updated_by_user']],
        'user_lojistiks_vehicle_types_updated_by_user' => [\Acorn\Lojistiks\Models\VehicleType::class, 'throughRelations' => ['user', 'lojistiks_vehicle_types_updated_by_user']],
        'user_lojistiks_vehicles_updated_by_user' => [\Acorn\Lojistiks\Models\Vehicle::class, 'throughRelations' => ['user', 'lojistiks_vehicles_updated_by_user']],
        'user_lojistiks_warehouses_updated_by_user' => [\Acorn\Lojistiks\Models\Warehouse::class, 'throughRelations' => ['user', 'lojistiks_warehouses_updated_by_user']],
        'user_lojistiks_brands_updated_by_user' => [\Acorn\Lojistiks\Models\Brand::class, 'throughRelations' => ['user', 'lojistiks_brands_updated_by_user']],
        'user_lojistiks_product_attributes_updated_by_user' => [\Acorn\Lojistiks\Models\ProductAttribute::class, 'throughRelations' => ['user', 'lojistiks_product_attributes_updated_by_user']],
        'user_finance_payments_created_by_user' => [\Acorn\Finance\Models\Payment::class, 'throughRelations' => ['user', 'finance_payments_created_by_user']],
        'user_finance_payments_updated_by_user' => [\Acorn\Finance\Models\Payment::class, 'throughRelations' => ['user', 'finance_payments_updated_by_user']],
        'user_criminal_detention_methods_created_by_user' => [\Acorn\Criminal\Models\DetentionMethod::class, 'throughRelations' => ['user', 'criminal_detention_methods_created_by_user']],
        'user_criminal_detention_methods_updated_by_user' => [\Acorn\Criminal\Models\DetentionMethod::class, 'throughRelations' => ['user', 'criminal_detention_methods_updated_by_user']],
        'user_criminal_detention_reasons_created_by_user' => [\Acorn\Criminal\Models\DetentionReason::class, 'throughRelations' => ['user', 'criminal_detention_reasons_created_by_user']],
        'user_criminal_detention_reasons_updated_by_user' => [\Acorn\Criminal\Models\DetentionReason::class, 'throughRelations' => ['user', 'criminal_detention_reasons_updated_by_user']],
        'user_criminal_defendant_crimes_updated_by_user' => [\Acorn\Criminal\Models\DefendantCrime::class, 'throughRelations' => ['user', 'criminal_defendant_crimes_updated_by_user']],
        'user_finance_currencies_created_by_user' => [\Acorn\Finance\Models\Currency::class, 'throughRelations' => ['user', 'finance_currencies_created_by_user']],
        'user_finance_currencies_updated_by_user' => [\Acorn\Finance\Models\Currency::class, 'throughRelations' => ['user', 'finance_currencies_updated_by_user']],
        'user_criminal_legalcase_types_created_by_user' => [\Acorn\Criminal\Models\LegalcaseType::class, 'throughRelations' => ['user', 'criminal_legalcase_types_created_by_user']],
        'user_criminal_legalcase_types_updated_by_user' => [\Acorn\Criminal\Models\LegalcaseType::class, 'throughRelations' => ['user', 'criminal_legalcase_types_updated_by_user']],
        'user_justice_legalcase_categories_created_by_user' => [\Acorn\Justice\Models\LegalcaseCategory::class, 'throughRelations' => ['user', 'justice_legalcase_categories_created_by_user']],
        'user_justice_legalcase_categories_updated_by_user' => [\Acorn\Justice\Models\LegalcaseCategory::class, 'throughRelations' => ['user', 'justice_legalcase_categories_updated_by_user']],
        'user_justice_warrant_types_created_by_user' => [\Acorn\Justice\Models\WarrantType::class, 'throughRelations' => ['user', 'justice_warrant_types_created_by_user']],
        'user_justice_warrant_types_updated_by_user' => [\Acorn\Justice\Models\WarrantType::class, 'throughRelations' => ['user', 'justice_warrant_types_updated_by_user']],
        'user_finance_receipts_created_by_user' => [\Acorn\Finance\Models\Receipt::class, 'throughRelations' => ['user', 'finance_receipts_created_by_user']],
        'user_finance_receipts_updated_by_user' => [\Acorn\Finance\Models\Receipt::class, 'throughRelations' => ['user', 'finance_receipts_updated_by_user']],
        'user_lojistiks_containers_updated_by_user' => [\Acorn\Lojistiks\Models\Container::class, 'throughRelations' => ['user', 'lojistiks_containers_updated_by_user']],
        'user_lojistiks_drivers_updated_by_user' => [\Acorn\Lojistiks\Models\Driver::class, 'throughRelations' => ['user', 'lojistiks_drivers_updated_by_user']],
        'user_lojistiks_product_product_category_created_by_user' => [\Acorn\Lojistiks\Models\ProductProductCategory::class, 'throughRelations' => ['user', 'lojistiks_product_product_category_created_by_user']],
        'user_messaging_message_user_users' => [\Acorn\Messaging\Models\Message::class, 'throughRelations' => ['user', 'messaging_message_user_users']],
        'user_user_language_user_users' => [\Acorn\User\Models\Language::class, 'throughRelations' => ['user', 'user_language_user_users']],
        'user_criminal_legalcase_prosecutor_users' => [\Acorn\Criminal\Models\Legalcase::class, 'throughRelations' => ['user', 'criminal_legalcase_prosecutor_users']],
        'user_user_user_group_version_user_users' => [\Acorn\User\Models\UserGroupVersion::class, 'throughRelations' => ['user', 'user_user_group_version_user_users']]
    ];
    public $actionFunctions = [];
    use \Winter\Storm\Database\Traits\Revisionable;
    use \Illuminate\Database\Eloquent\Concerns\HasUuids;


    protected $revisionable = [];
    public $timestamps = 0;
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
    protected $dates = [];

    /**
     * @var array Relations
     */
    public $hasOne = [];
    public $hasMany = [
        'lojistiks_drivers_person' => [\Acorn\Lojistiks\Models\Driver::class, 'key' => 'person_id', 'type' => '1fromX'],
        'lojistiks_employees_person' => [\Acorn\Lojistiks\Models\Employee::class, 'key' => 'person_id', 'type' => '1fromX']
    ];
    public $hasOneThrough = [];
    public $hasManyThrough = [];
    public $belongsTo = [
        'user' => [\Acorn\User\Models\User::class, 'key' => 'user_id', 'name' => TRUE, 'type' => '1to1'],
        'server' => [\Acorn\Models\Server::class, 'key' => 'server_id', 'type' => 'Xto1'],
        'created_at_event' => [\Acorn\Calendar\Models\Event::class, 'key' => 'created_at_event_id', 'type' => 'Xto1'],
        'created_by_user' => [\Acorn\User\Models\User::class, 'key' => 'created_by_user_id', 'type' => 'Xto1'],
        'last_transfer_location' => [\Acorn\Location\Models\Location::class, 'key' => 'last_transfer_location_id', 'type' => 'Xto1'],
        'last_product_instance_location' => [\Acorn\Location\Models\Location::class, 'key' => 'last_product_instance_location_id', 'type' => 'Xto1']
    ];
    public $belongsToMany = [];
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
