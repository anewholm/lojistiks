<?php Block::put('breadcrumb') ?>
    <ul>
        <li><a href="<?= Backend::url('acorn/lojistiks/drivers') ?>"><?= e(trans('acorn.lojistiks::lang.models.driver.label_plural')); ?></a></li>
        <li><?= e($this->pageTitle) ?></li>
    </ul>
<?php Block::endPut() ?>

<?php if (!$this->fatalError): ?>

    <div class="form-preview">
        <?= $this->formRenderPreview() ?>
    </div>

<?php else: ?>

    <p class="flash-message static error"><?= e($this->fatalError) ?></p>
    <p><a href="<?= Backend::url('acorn/lojistiks/drivers') ?>" class="btn btn-default"><?= e(trans('backend::lang.form.return_to_list')); ?></a></p>

<?php endif ?>
