<?php namespace AcornAssociated\Lojistiks;

use Schema;
use System\Classes\PluginBase;
use Illuminate\Support\Facades\Event;
use \AcornAssociated\Calendar\Listeners\MixinEvents;
use \AcornAssociated\Messaging\Events\MessageListReady;
use Backend\Models\User;
use Backend\Models\UserGroup;
use Backend\Controllers\Users;
use \AcornAssociated\Messaging\Controllers\Conversations;
use \AcornAssociated\Messaging\Models\Message;
use \AcornAssociated\Calendar\Models\Calendar;
use \AcornAssociated\Calendar\Models\Instance;
use \AcornAssociated\Calendar\Models\EventPart;

class Plugin extends PluginBase
{
    use \System\Traits\AssetMaker;

    public function registerSettings()
    {
        return [
            'settings' => [
                'label'       => 'Lojistiks Settings',
                'description' => 'Manage lojistiks based settings.',
                'category'    => 'Lojistiks',
                'icon'        => 'icon-cog',
                'class'       => 'AcornAssociated\Lojistiks\Models\Settings',
                'order'       => 500,
                'keywords'    => 'lojistiks',
                'permissions' => ['acornassociated.lojistiks.settings']
            ]
        ];
    }
}
