<?php namespace AcornAssociated\Lojistiks\Controllers;

use BackendMenu;
use AcornAssociated\Controller;

/**
 * Product Attributes Backend Controller
 */
class ProductAttributes extends Controller
{
    public $bodyClass = 'compact-container';
    /**
     * @var array Behaviors that are implemented by this controller.
     */
    public $implement = [
        '\AcornAssociated\Behaviors\FormController',
        '\AcornAssociated\Behaviors\ListController',
        'Backend\Behaviors\RelationController',
        '\AcornAssociated\Behaviors\RelationController'
    ];

    public function __construct()
    {
        parent::__construct();

        BackendMenu::setContext('AcornAssociated.Lojistiks', 'lojistiks', 'productattributes');
    }
}
