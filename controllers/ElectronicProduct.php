<?php namespace AcornAssociated\Lojistiks\Controllers;

use BackendMenu;
use AcornAssociated\Controller;
// use AcornAssociated\Controller;

/**
 * Electronic Product Backend Controller
 */
class ElectronicProduct extends Controller
{
    /**
     * @var array Behaviors that are implemented by this controller.
     */
    public $implement = [
        \Backend\Behaviors\FormController::class,
        \Backend\Behaviors\ListController::class,
    ];

    public function __construct()
    {
        parent::__construct();

        BackendMenu::setContext('AcornAssociated.Lojistiks', 'lojistiks', 'electronicproduct');
    }
}
