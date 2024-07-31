<?php

return [
    'plugin' => [
        'name' => 'Lojistiks',

        // Menu-Items

        'warehousing' => 'Warehouse',
        'product-instances' => 'Items',
        'stock_take' => 'Stock Take',
        'transfer_items' => 'Transfer Items',

        // Setup

        'setup' => 'Setup',
        'measurement_units' => 'Measurement Units',
        'brands' => 'Brands',
        'products' => 'Products',
        'addresses' => 'Addresses',
        'offices' => 'Offices',
        'warehouses' => 'Warehouses',
        'areas' => 'Areas',
        'computer_products' => 'Computer Products',
        'electronic_products' => 'Electronic Products',
        'persons' => 'Persons',
        'suppliers' => 'Suppliers',
        'transfers' => 'Transfers',
        'vehicles' => 'Vehicles',
    ],
    'models' => [
        'general' => [
            'id' => 'ID',
            'name' => 'Name',
            'select' => 'Select',
            'created_at' => 'Created At',
            'updated_at' => 'Updated At',
            'scan_qrcode' => 'Scan A QRCode',
            'find_by_qrcode' => 'Find by QRCode',
            'print' => 'Print',
        ],
        'product' => [
            'label' => 'General Product',
            'label_plural' => 'General Products',
            'model' => 'Model',
            'external_identifier' => 'Serial number',
            'asset_class' => 'Asset Class',
        ],
        'measurementunit' => [
            'label' => 'Measurement Unit',
            'label_plural' => 'Measurement Units',
            'uses_quantity' => 'Uses Quantity',
            'short_name' => 'Short Name',
        ],
        'brand' => [
            'label' => 'Brand',
            'label_plural' => 'Brands',
        ],
        'productinstance' => [
            'label' => 'Product Instance',
            'label_plural' => 'Product Instances',
            'quantity' => 'Quantity',
        ],
        'area' => [
            'label' => 'Area',
            'label_plural' => 'Areas',
            'parent_area' => 'Containing Area',
        ],
        'address' => [
            'label' => 'Address',
            'label_plural' => 'Addresses',
            'number' => 'Number',
            'street' => 'Street',
            'longitude' => 'Longitude',
            'latitude' => 'Latitude',
            'auto_location' => 'Create an associated Location',
        ],
        'office' => [
            'label' => 'Office',
            'label_plural' => 'Offices',
        ],
        'warehouse' => [
            'label' => 'Warehouse',
            'label_plural' => 'Warehouses',
        ],
        'computerproduct' => [
            'label' => 'Computer Product',
            'label_plural' => 'Computer Products',
            'memory' => 'Memory',
            'hdd_size' => 'HDD Size',
            'processor_type' => 'Processor Type',
            'processor_version' => 'Processor Version',
        ],
        'electronicproduct' => [
            'label' => 'Electronic Product',
            'label_plural' => 'Electronic Products',
        ],
        'person' => [
            'label' => 'Person',
            'label_plural' => 'People',
            'first_name' => 'First Name',
            'last_name' => 'Last Name',
            'login' => 'Login',
            'email' => 'Email',
            'password' => 'Password',
        ],
        'supplier' => [
            'label' => 'Supplier',
            'label_plural' => 'Suppliers',
        ],
        'transfer' => [
            'label' => 'Transfer',
            'label_plural' => 'Transfers',
            'add_product_instance' => 'Add Item',
            'send' => 'Send',
            'send_and_close' => 'Send and Close',
            'source_location' => 'Source Location',
            'destination_location' => 'Destination Location',
        ],
        'vehicle' => [
            'label' => 'Vehicle',
            'label_plural' => 'Vehicles',
            'registration' => 'Registration',
        ],
        'location' => [
            'label' => 'Location',
            'label_plural' => 'Locations',
        ],
        'gp' => [
            'label' => 'GPS',
            'label_plural' => 'GPSs',
            'longitude' => 'Longitude',
            'latitude' => 'Latitude',
        ],
        'areatype' => [
            'label' => 'Area Type',
            'label_plural' => 'Area Types',
        ],
        'driver' => [
            'label' => 'Driver',
            'label_plural' => 'Drivers',
        ],
        'vehicletype' => [
            'label' => 'Type',
            'label_plural' => 'Vehicle Types',
        ],
    ],
];
