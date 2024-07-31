<?php namespace AcornAssociated\Lojistiks\Controllers;

use BackendMenu;
use AcornAssociated\Controller;

/**
 * Person Backend Controller
 */
class Person extends Controller
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

        BackendMenu::setContext('AcornAssociated.Lojistiks', 'lojistiks', 'person');
    }
}
