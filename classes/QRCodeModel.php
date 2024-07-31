<?php
namespace Acorn\Lojistiks\Classes;

use Acorn\Model;
use Flash;

/* QRCodeModel fields can be set by the QRCode reader
 * They also display QRCodes
 */
class QRCodeModel extends Model {
    protected static function getShortName($object)
    {
        // Short name for debugging output
        // Acorn\Lojistiks\Model\Area => Area
        if (!is_string($object)) {
            $object = get_class($object);
        }
        return last(explode('\\', $object));
    }

    public function filterFields($fields, $context = NULL)
    {
        static $qrCodes = [];
        $is_update = ($context == 'update');
        $is_create = ($context == 'create');

        if ($is_update || $is_create) {
            $this_class = self::getShortName($this); // e.g. Transfer

            if ($post = post($this_class)) { // Transfer[...]
                if (isset($post['qrcode']) && $post['qrcode']) {
                    if ($qrcode = json_decode($post['qrcode'])) {
                        $debug             = (isset($qrcode->debug) && $qrcode->debug);
                        $fqClass           = "$qrcode->author\\$qrcode->plugin\\Models\\$qrcode->model";
                        $scannedObject     = $fqClass::findOrFail($qrcode->id);
                        $scannedObjectName = (method_exists($scannedObject, 'name') ?  $scannedObject->name() : $scannedObject->id());
                        $scannedModel      = get_class($scannedObject);
                        $scannedModelName  = self::getShortName($scannedModel);
                        $scannedRelations  = [];
                        $scannedFields     = [];
                        $foundField        = FALSE;

                        // Only process a QR code once
                        if ($scannedObject) {
                            // Check each field for scanned object and its relations
                            foreach ($fields as $fieldName => &$field) {
                                $fieldType    = $field->config['type'];
                                $fieldDetails = '';

                                if ($fieldType == 'relation') {
                                    // ----------------------------------------- Field Model type
                                    // From relations
                                    // and details
                                    $relation           = NULL;
                                    $isCollection       = FALSE;
                                    if      (isset($this->hasOne[$fieldName]))         $relation = 'hasOne';
                                    else if (isset($this->belongsTo[$fieldName]))      $relation = 'belongsTo';
                                    else if (isset($this->belongsToMany[$fieldName])) {$relation = 'belongsToMany'; $isCollection  = TRUE;}
                                    else if (isset($this->hasMany[$fieldName]))       {$relation = 'hasMany';       $isCollection  = TRUE;}

                                    if ($relation) {
                                        $fieldRelationModel = $this->$relation[$fieldName];
                                        if (is_array($fieldRelationModel)) $fieldRelationModel = $fieldRelationModel[0];
                                        $fieldRelationModelName = self::getShortName($fieldRelationModel);
                                        $fieldDetails .= "\$${relation}[$fieldName => $fieldRelationModelName::class]";
                                        if ($isCollection && $field->value && !$field->value instanceof Collection) throw new Exception('Not collection');
                                        $canHaveValue  = (is_null($field->value) || $isCollection || $is_update);
                                        $fieldDetails .= ($canHaveValue ? '-' : '') . ($isCollection ? '*' : '');

                                        // We do not overwrite set values
                                        if ($canHaveValue) {
                                            // ----------------------------------------------- Direct set
                                            if ($fieldRelationModel == $scannedModel) {
                                                // Set value
                                                if ($isCollection) $field->value->push($scannedObject);
                                                else $field->value = $scannedObject->id();

                                                // Debug output
                                                array_push($scannedFields, "$fieldDetails direct");
                                                $scannedFieldsText = implode("\n", $scannedFields);

                                                // Response
                                                Flash::success(trans("$scannedModelName($scannedObjectName) direct found on form at $fieldDetails"));
                                                $foundField = TRUE;
                                                break;
                                            }

                                            // ----------------------------------------------- Scanned Object Relation hasOne
                                            foreach ($scannedObject->hasOne as $scannedRelationName => $scannedRelationModel) {
                                                $scannedObject->load($scannedRelationName);
                                                if (is_array($scannedRelationModel)) $scannedRelationModel = $scannedRelationModel[0];
                                                array_push($scannedRelations, self::getShortName($scannedRelationModel));

                                                if (isset($scannedObject->$scannedRelationName) && $fieldRelationModel == $scannedRelationModel) {
                                                    // Set value
                                                    if ($isCollection) $field->push($scannedObject->$scannedRelationName);
                                                    else $field->value = $scannedObject->$scannedRelationName->id;

                                                    // Debug output
                                                    $scannedRelationModelName = self::getShortName($scannedRelationModel);
                                                    array_push($scannedFields, "$fieldDetails hasOne[$scannedRelationModelName]");
                                                    $scannedFieldsText = implode("\n", $scannedFields);

                                                    // Response
                                                    Flash::success(trans("$scannedModelName($scannedObjectName)->$scannedRelationName found on form at $fieldDetails"));
                                                    $foundField = TRUE;
                                                    break;
                                                }
                                            }

                                            // ----------------------------------------------- Scanned Object Relation belongsTo
                                            foreach ($scannedObject->belongsTo as $scannedRelationName => $scannedRelationModel) {
                                                $scannedObject->load($scannedRelationName);
                                                if (is_array($scannedRelationModel)) $scannedRelationModel = $scannedRelationModel[0];
                                                array_push($scannedRelations, self::getShortName($scannedRelationModel));

                                                if (isset($scannedObject->$scannedRelationName) && $fieldRelationModel == $scannedRelationModel) {
                                                    // Set value
                                                    if ($isCollection) $field->push($scannedObject->$scannedRelationName);
                                                    else $field->value = $scannedObject->$scannedRelationName->id();

                                                    // Debug output
                                                    $scannedRelationModelName = self::getShortName($scannedRelationModel);
                                                    array_push($scannedFields, "$fieldDetails belongsTo[$scannedRelationModelName]");
                                                    $scannedFieldsText = implode("\n", $scannedFields);

                                                    // Response
                                                    Flash::success(trans("$scannedModelName($scannedObjectName)->$scannedRelationName found on form at $fieldDetails"));
                                                    $foundField = TRUE;
                                                    break;
                                                }
                                            }

                                            // ----------------------------------------------- Scanned Object Relation hasMany
                                            foreach ($scannedObject->hasMany as $scannedRelationName => $scannedRelationModel) {
                                                $scannedObject->load($scannedRelationName);
                                                if (is_array($scannedRelationModel)) $scannedRelationModel = $scannedRelationModel[0];
                                                array_push($scannedRelations, self::getShortName($scannedRelationModel));

                                                if (isset($scannedObject->$scannedRelationName) && $fieldRelationModel == $scannedRelationModel) {
                                                    // Set value
                                                    if ($isCollection) {
                                                        dd($field);
                                                        $field->value->push($scannedObject->$scannedRelationName);
                                                    } else $field->value = $scannedObject->$scannedRelationName->id();

                                                    // Debug output
                                                    $scannedRelationModelName = self::getShortName($scannedRelationModel);
                                                    array_push($scannedFields, "$fieldDetails hasMany[$scannedRelationModelName]");
                                                    $scannedFieldsText = implode("\n", $scannedFields);

                                                    // Response
                                                    Flash::success(trans("$scannedModelName($scannedObjectName)->$scannedRelationName found on form at $fieldDetails"));
                                                    $foundField = TRUE;
                                                    break;
                                                }
                                            }
                                        } else $fieldDetails .= " cannotHaveValue[]";
                                    } else $fieldDetails .= " noRelationFor[$fieldType]";

                                    if ($foundField) break;
                                    array_push($scannedFields, $fieldDetails);
                                } // Not a relation
                            } // foreach &$field

                            if ($foundField === FALSE) {
                                $scannedFieldsText = implode("\n", $scannedFields);
                                if (count($scannedRelations)) {
                                    $scannedRelationsText = implode(', ', $scannedRelations);
                                    Flash::error("$scannedModelName, $scannedRelationsText " . trans("not found on form") . ", $scannedFieldsText");
                                } else Flash::error($scannedModelName . trans(" not found on form") . ", $scannedFieldsText");
                            }
                        } else {
                            $notFound = trans("not found");
                            Flash::error("$fqClass::$qrcode->id $notFound");
                        }
                    }
                }
            }
        }

        return TRUE;
    }
}
