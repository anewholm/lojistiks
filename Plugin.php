<?php

namespace Acorn\Lojistiks;

use Backend;
use Backend\Models\UserRole;
use System\Classes\PluginBase;

/**
 * Lojistiks Plugin Information File
 */
class Plugin extends PluginBase
{
    public $require = [
        'Acorn.Calendar',
        'Acorn.Location',
        'Acorn.Messaging',
        'Acorn.User',
        'Acorn.Finance'
    ];
    /**
     * Returns information about this plugin.
     */
    public function pluginDetails(): array
    {
        return [
            'name'        => 'acorn.lojistiks::lang.plugin.name',
            'description' => 'acorn.lojistiks::lang.plugin.description',
            'author' => 'Acorn',
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
            'Acorn\Lojistiks\Components\MyComponent' => 'myComponent',
        ];
    }

    /**
     * Registers any backend permissions used by this plugin.
     */
    public function registerPermissions(): array
    {
        return []; // Remove this line to activate

        return [
            'acorn.lojistiks.some_permission' => [
                'tab' => 'acorn.lojistiks::lang.plugin.name',
                'label' => 'acorn.lojistiks::lang.permissions.some_permission',
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
                'label'       => 'acorn.lojistiks::lang.plugin.name',
                'url'         => Backend::url('acorn/lojistiks/mycontroller'),
                'icon'        => 'icon-leaf',
                'permissions' => ['acorn.lojistiks.*'],
                'order'       => 500,
            ],
        ];
    }
}

// Created By acorn-create-system v1.0
