<?php namespace Acorn\Lojistiks\Controllers;

use BackendMenu;
use Backend\Classes\Controller;

/**
 * Stock Products Backend Controller
 */
class StockProducts extends Controller
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

        BackendMenu::setContext('Acorn.Lojistiks', 'lojistiks', 'stockproducts');
    }
}
