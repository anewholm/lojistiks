<?php namespace Acorn\Lojistiks;

use Schema;
use System\Classes\PluginBase;
use Illuminate\Support\Facades\Event;
use \Acorn\Calendar\Listeners\MixinEvents;
use \Acorn\Messaging\Events\MessageListReady;
use Backend\Models\User;
use Backend\Models\UserGroup;
use Backend\Controllers\Users;
use \Acorn\Messaging\Controllers\Conversations;
use \Acorn\Messaging\Models\Message;
use \Acorn\Calendar\Models\Calendar;
use \Acorn\Calendar\Models\Instance;
use \Acorn\Calendar\Models\EventPart;

class Plugin extends PluginBase
{
    use \System\Traits\AssetMaker;

    /**
     * @var array Plugin dependencies
     */
    public $require = ['Acorn.Calendar', 'Acorn.Location', 'Acorn.Messaging', 'Acorn.Finance'];

    public function registerSettings()
    {
        return [
            'settings' => [
                'label'       => 'Lojistiks Settings',
                'description' => 'Manage lojistiks based settings.',
                'category'    => 'Lojistiks',
                'icon'        => 'icon-cog',
                'class'       => 'Acorn\Lojistiks\Models\Settings',
                'order'       => 500,
                'keywords'    => 'lojistiks',
                'permissions' => ['acorn.lojistiks.settings']
            ]
        ];
    }

    public function registerPermissions()
    {
        return [
            'acorn.lojistiks.debug' => [
                'label' => 'View Debug info',
                'tab'   => 'Acorn',
            ],
        ];
    }
}
