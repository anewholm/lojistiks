<?php namespace Acorn\Lojistiks\Controllers;

use BackendMenu;
use Acorn\Controller;

/**
 * Product Products Backend Controller
 */
class ProductProducts extends Controller
{
    /**
     * @var array Behaviors that are implemented by this controller.
     */
    public $implement = [
        '\Acorn\Behaviors\FormController',
        '\Acorn\Behaviors\ListController',
        'Backend\Behaviors\RelationController',
        '\Acorn\Behaviors\RelationController'
    ];

    public function __construct()
    {
        parent::__construct();

        BackendMenu::setContext('Acorn.Lojistiks', 'lojistiks', 'productproducts');
    }
}