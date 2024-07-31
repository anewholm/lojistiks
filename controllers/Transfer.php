<?php namespace AcornAssociated\Lojistiks\Controllers;

use BackendMenu;
use AcornAssociated\Controller;

/**
 * Transfer Backend Controller
 */
class Transfer extends Controller
{
    /**
     * @var array Behaviors that are implemented by this controller.
     */
    public $implement = [
        \Backend\Behaviors\FormController::class,
        \Backend\Behaviors\ListController::class,
        \Backend\Behaviors\RelationController::class,
    ];

    public function __construct()
    {
        parent::__construct();

        BackendMenu::setContext('AcornAssociated.Lojistiks', 'lojistiks', 'transfer');
    }
}
