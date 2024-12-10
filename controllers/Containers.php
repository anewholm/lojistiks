<?php namespace Acorn\Lojistiks\Controllers;

use BackendMenu;
use Acorn\Controller;

/**
 * Containers Backend Controller
 */
class Containers extends Controller
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

        BackendMenu::setContext('Acorn.Lojistiks', 'lojistiks', 'containers');
    }
}