<?php Block::put('breadcrumb') ?>
    <ul>
        <li><a href="<?= Backend::url('acorn/lojistiks/vehicles') ?>"><?= e(trans('acorn.lojistiks::lang.models.vehicle.label_plural')); ?></a></li>
        <li><?= e($this->pageTitle) ?></li>
    </ul>
<?php Block::endPut() ?>

<?php if (!$this->fatalError): ?>

    <?= Form::open(['class' => 'layout']) ?>

        <div class="layout-row">
            <?= $this->formRender() ?>
        </div>

        <div class="form-buttons">
            <div class="loading-indicator-container">
                <button
                    type="button"
                    data-request="onSave"
                    data-request-data="action: 'acorn/lojistiks/vehicles/preview'"
                    data-hotkey="ctrl+s, cmd+s"
                    data-load-indicator="<?= e(trans('backend::lang.form.creating_name', ['name' => trans('acorn.lojistiks::lang.models.driver.label')])); ?>"
                    class="btn btn-primary">
                    <?= e(trans('acorn.lojistiks::lang.models.general.correct_and_print')); ?>
                </button>
                <button
                    type="button"
                    data-request="onSave"
                    data-request-data="redirect:0"
                    data-hotkey="ctrl+s, cmd+s"
                    data-load-indicator="<?= e(trans('backend::lang.form.saving_name', ['name' => trans('acorn.lojistiks::lang.models.vehicle.label')])); ?>"
                    class="btn btn-primary">
                    <?= e(trans('backend::lang.form.save')); ?>
                </button>
                <button
                    type="button"
                    data-request="onSave"
                    data-request-data="close:1"
                    data-hotkey="ctrl+enter, cmd+enter"
                    data-load-indicator="<?= e(trans('backend::lang.form.saving_name', ['name' => trans('acorn.lojistiks::lang.models.vehicle.label')])); ?>"
                    class="btn btn-default">
                    <?= e(trans('backend::lang.form.save_and_close')); ?>
                </button>
                <button
                    type="button"
                    class="wn-icon-trash-o btn-icon danger pull-right"
                    data-request="onDelete"
                    data-load-indicator="<?= e(trans('backend::lang.form.deleting_name', ['name' => trans('acorn.lojistiks::lang.models.vehicle.label')])); ?>"
                    data-request-confirm="<?= e(trans('backend::lang.form.confirm_delete')); ?>">
                </button>
                <span class="btn-text">
                    or <a href="<?= Backend::url('acorn/lojistiks/vehicles') ?>"><?= e(trans('backend::lang.form.cancel')); ?></a>
                </span>
            </div>
        </div>

    <?= Form::close() ?>

<?php else: ?>

    <p class="flash-message static error"><?= e($this->fatalError) ?></p>
    <p><a href="<?= Backend::url('acorn/lojistiks/vehicles') ?>" class="btn btn-default"><?= e(trans('backend::lang.form.return_to_list')); ?></a></p>

<?php endif ?>