<?php

$app->on('admin.init', function() {
    $this->helper('admin')->addAssets('multiplecollectionlink:assets/component.js');
    $this->helper('admin')->addAssets('multiplecollectionlink:assets/field-multiplecollectionlink.tag');
});
