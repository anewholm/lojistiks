<?php namespace Acorn\Lojistiks\Controllers;

use BackendMenu;
use Backend\Classes\Controller;
use Acorn\Model;
use Acorn\Lojistiks\Models\Brand;
use Acorn\Lojistiks\Events\DataChange;

/**
 * D B Backend Controller
 */
class DB extends Controller
{
    /**
     * @var array Behaviors that are implemented by this controller.
     */
    public $implement = [
        \Backend\Behaviors\FormController::class,
        \Backend\Behaviors\ListController::class,
    ];

    public $TG_NAME;
    public $TG_OP;
    public $TG_TABLE_SCHEMA;
    public $TG_TABLE_NAME;
    public $ID;

    public $tableName;
    public $modelClass;

    public function __construct()
    {
        parent::__construct();

        BackendMenu::setContext('Acorn.Lojistiks', 'lojistiks', 'db');
    }

    public function newrow()
    {
        // See API route in routes.php
        // /api/newrow
        // See Database function fn_acorn_lojistiks_new_replicated_row()
        try {
            $this->TG_NAME = $_GET['TG_NAME'];
            $this->TG_OP   = $_GET['TG_OP'];
            $this->TG_TABLE_SCHEMA = $_GET['TG_TABLE_SCHEMA'];
            $this->TG_TABLE_NAME   = $_GET['TG_TABLE_NAME'];
            $this->ID      = $_GET['ID']; // UUID
        } catch (Exception $ex) {
            throw $ex;
        }

        // Auto-load all our Models
        $dirSep     = DIRECTORY_SEPARATOR;
        $pluginPath = dirname(dirname(__FILE__));
        $modelsPath = "$pluginPath/models";
        foreach (scandir($modelsPath) as $key => $file) {
            $filePath = "$modelsPath$dirSep$file";
            if ( ! is_dir($filePath)) {
                $className   = str_replace('.php', '', $file);
                $fqClassName = "Acorn\\Lojistiks\\Models\\$className";
                if (!class_exists($fqClassName)) new $fqClassName();
            }
        }

        // Search for the correct one
        $this->tableName = "$this->TG_TABLE_SCHEMA.$this->TG_TABLE_NAME";
        $response        = "$this->tableName Not found";
        if ($this->modelClass = Model::fromTableName($this->tableName)) {
            // NOTE: The DB transaction is not complete at this point
            // So we cannot load the model yet
            // HTML attributes for listening to a channel:
            // TODO: websocket-listen="lojistiks" websocket-ondb-insert="'name-of-ajax-call': '#id-of-html-component'"
            DataChange::dispatch($this); // channel=lojistiks, data.change
            $response = "$this->modelClass($this->ID) Dispatched";
        } else {
            http_response_code(404);
        }

        return $response;
    }
}
