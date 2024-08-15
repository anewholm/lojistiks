<?php
use Acorn\Lojistiks\Controllers\DB;

Route::get('/api/newrow', DB::class . '@newrow');
