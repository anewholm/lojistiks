<div data-control="toolbar">
    <a
        href="<?= Backend::url('acorn/lojistiks/productinstance/create') ?>"
        class="btn btn-primary wn-icon-plus">
        <?= e(trans('backend::lang.form.create_title', ['name' => trans('acorn.lojistiks::lang.models.productinstance.label')])); ?>
    </a>

    <button
        class="btn btn-danger wn-icon-trash-o"
        disabled="disabled"
        onclick="$(this).data('request-data', { checked: $('.control-list').listWidget('getChecked') })"
        data-request="onDelete"
        data-request-confirm="<?= e(trans('backend::lang.list.delete_selected_confirm')); ?>"
        data-trigger-action="enable"
        data-trigger=".control-list input[type=checkbox]"
        data-trigger-condition="checked"
        data-request-success="$(this).prop('disabled', 'disabled')"
        data-stripe-load-indicator>
        <?= e(trans('backend::lang.list.delete_selected')); ?>
    </button>

    <a
        href="/backend/acorn/lojistiks/findbyqrcode"
        class="btn btn-primary wn-icon-plus">
        <?= e(trans('acorn.lojistiks::lang.models.general.find_by_qrcode', ['name' => trans('acorn.lojistiks::lang.general.find_by_qrcode')])); ?>
    </a>

    <a
        href="javascript:print()"
        class="btn btn-primary wn-icon-print">
        <?= e(trans('acorn.lojistiks::lang.models.general.print', ['name' => trans('acorn.lojistiks::lang.general.print')])); ?>
    </a>
</div>
