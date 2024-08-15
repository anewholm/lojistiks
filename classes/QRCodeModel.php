<?php
namespace Acorn\Lojistiks\Classes;

use Acorn\Model;
use Flash;
use Exception;

/* QRCodeModel fields can be set by the QRCode reader
 * They also display QRCodes
 */
class QRCodeModel extends Model {
    public function filterFields($fields, $context = NULL)
    {
        $is_update = ($context == 'update');
        $is_create = ($context == 'create');

        if ($is_update || $is_create) {
            if ($post = post($this->getShortClassName())) { // Transfer[...]
                if (isset($post['qrcode']) && $post['qrcode']) {
                    if ($qrcode = json_decode($post['qrcode'])) {
                        $qrClass      = "$qrcode->author\\$qrcode->plugin\\Models\\$qrcode->model";
                        $qrObject     = $qrClass::findOrFail($qrcode->id); // throws Exception
                        $qrObjectName = (method_exists($qrObject, 'name') ?  $qrObject->name() : $qrObject->id());
                        // names => classes
                        $fieldsRelations   = array_merge($this->hasOne,     $this->belongsTo,     $this->hasMany,     $this->belongsToMany);
                        $qrObjectRelations = array_merge($qrObject->hasOne, $qrObject->belongsTo, $qrObject->hasMany, $qrObject->belongsToMany);

                        // Check each field for qr object and its relations
                        $field          = NULL;
                        $relevantObject = NULL;
                        foreach ($fields as $fieldName => &$field) {
                            // We only accept relations at the moment
                            if (isset($fieldsRelations[$fieldName])) {
                                $fieldRelationModel = $fieldsRelations[$fieldName];
                                if (is_array($fieldRelationModel)) $fieldRelationModel = $fieldRelationModel[0];

                                // We do not overwrite set values
                                $canHaveValue = (is_null($field->value) || is_array($field->value) || $is_update);
                                if ($canHaveValue) {
                                    // ----------------------------------------------- Direct set
                                    if ($fieldRelationModel == $qrClass) {
                                        $relevantObject = $qrObject;
                                        $foundAtText    = "$qrcode->model($qrObjectName) direct";
                                        break;
                                    }

                                    // ----------------------------------------------- Scanned Object Relations
                                    foreach ($qrObjectRelations as $qrObjectRelationName => $qrObjectRelationModel) {
                                        $qrObject->load($qrObjectRelationName);
                                        if (is_array($qrObjectRelationModel)) $qrObjectRelationModel = $qrObjectRelationModel[0];
                                        if (isset($qrObject->$qrObjectRelationName) && $fieldRelationModel == $qrObjectRelationModel) {
                                            $relevantObject = $qrObject->$qrObjectRelationName;
                                            $foundAtText    = "$qrcode->model($qrObjectName)->$qrObjectRelationName";
                                            break;
                                        }
                                    }
                                } // cannot Have a Value
                            } // not a relation

                            if ($relevantObject) break; // We accept the first only
                        } // foreach &$field

                        if ($relevantObject) {
                            // Set the field value
                            if (is_array($field->value)) array_push($field->value, $relevantObject->id());
                            else                         $field->value = $relevantObject->id();

                            // Response
                            $foundOnForm = trans("found on form");
                            Flash::success(trans("$foundAtText $foundOnForm @ $fieldName"));
                        } else {
                            $notFoundOnForm = trans("not found on form");
                            Flash::error("$qrcode->model $notFoundOnForm");
                        }
                    }
                }
            }
        }
    }
}
