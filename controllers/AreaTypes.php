<?php namespace Acorn\Lojistiks\Controllers;

use BackendMenu;
use Acorn\Controller;

/**
 * Area Type Backend Controller
 */
class AreaTypes extends Controller
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

        BackendMenu::setContext('Acorn.Lojistiks', 'lojistiks', 'areatypes');
    }
}
