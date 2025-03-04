<?php namespace Acorn\Lojistiks\Controllers;

use BackendMenu;
use Acorn\Controller;

/**
 * Product Category Types Backend Controller
 */
class ProductCategoryTypes extends Controller
{
    public $bodyClass = 'compact-container';
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

        BackendMenu::setContext('Acorn.Lojistiks', 'lojistiks', 'productcategorytypes');
    }
}
