<?php

namespace AcornAssociated\Lojistiks;

use Backend;
use Backend\Models\UserRole;
use System\Classes\PluginBase;

/**
 * Lojistiks Plugin Information File
 */
class Plugin extends PluginBase
{
    public $require = [
        'AcornAssociated.Calendar',
        'AcornAssociated.Location',
        'AcornAssociated.Messaging',
        'AcornAssociated.User',
        'AcornAssociated.Finance'
    ];
    /**
     * Returns information about this plugin.
     */
    public function pluginDetails(): array
    {
        return [
            'name'        => 'acornassociated.lojistiks::lang.plugin.name',
            'description' => 'acornassociated.lojistiks::lang.plugin.description',
            'author' => 'Acorn Associated',
            'icon'        => 'icon-leaf'
        ];
    }

    /**
     * Register method, called when the plugin is first registered.
     */
    public function register(): void
    {

    }

    /**
     * Boot method, called right before the request route.
     */
    public function boot(): void
    {

    }

    /**
     * Registers any frontend components implemented in this plugin.
     */
    public function registerComponents(): array
    {
        return []; // Remove this line to activate

        return [
            'AcornAssociated\Lojistiks\Components\MyComponent' => 'myComponent',
        ];
    }

    /**
     * Registers any backend permissions used by this plugin.
     */
    public function registerPermissions(): array
    {
        return []; // Remove this line to activate

        return [
            'acornassociated.lojistiks.some_permission' => [
                'tab' => 'acornassociated.lojistiks::lang.plugin.name',
                'label' => 'acornassociated.lojistiks::lang.permissions.some_permission',
                'roles' => [UserRole::CODE_DEVELOPER, UserRole::CODE_PUBLISHER],
            ],
        ];
    }

    /**
     * Navigation in plugin.yaml.
     */
    public function registerNavigation_REMOVED(): array
    {
        return []; // Remove this line to activate

        return [
            'lojistiks' => [
                'label'       => 'acornassociated.lojistiks::lang.plugin.name',
                'url'         => Backend::url('acornassociated/lojistiks/mycontroller'),
                'icon'        => 'icon-leaf',
                'permissions' => ['acornassociated.lojistiks.*'],
                'order'       => 500,
            ],
        ];
    }
}

// Created By acorn-create-system v1.0
