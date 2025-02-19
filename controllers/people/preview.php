<?php Block::put('breadcrumb') ?>
    <ul>
        <li><a href="<?= Backend::url('acornassociated/lojistiks/people') ?>"><?= e(trans('acornassociated.lojistiks::lang.models.person.label_plural')); ?></a></li>
        <li><?= e($this->pageTitle) ?></li>
    </ul>
<?php Block::endPut() ?>

<?php if (!$this->fatalError): ?>

    <div class="form-preview">
        <?= $this->formRenderPreview() ?>
    </div>

<?php else: ?>

    <p class="flash-message static error"><?= e($this->fatalError) ?></p>
    <p><a href="<?= Backend::url('acornassociated/lojistiks/people') ?>" class="btn btn-default"><?= e(trans('backend::lang.form.return_to_list')); ?></a></p>

<?php endif ?>
