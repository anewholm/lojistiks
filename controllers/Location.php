<?php namespace AcornAssociated\Lojistiks\Controllers;

use BackendMenu;
use AcornAssociated\Controller;

/**
 * Location Backend Controller
 */
class Location extends Controller
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

        BackendMenu::setContext('AcornAssociated.Lojistiks', 'lojistiks', 'location');
    }
}
