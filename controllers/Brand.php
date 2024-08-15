<?php namespace Acorn\Lojistiks\Controllers;

use BackendMenu;
use Acorn\Controller;

/**
 * Brand Backend Controller
 */
class Brand extends Controller
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

        // TODO: Add acorn.websocket.js globally
        $this->addJs('/modules/acorn/assets/js/acorn.websocket.js', array('type' => 'module'));
        $this->addJs('/modules/acorn/assets/js/acorn.js');
        $this->addCss('/modules/acorn/assets/css/forms.css');

        BackendMenu::setContext('Acorn.Lojistiks', 'lojistiks', 'brand');
    }

    public function onRefreshList()
    {
        $this->makeLists();
        return $this->listRender();
    }
}
