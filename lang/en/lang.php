<?php return [
    'plugin' => [
        'name' => 'Lojistiks',
        'description' => 'Created By acorn-create-system v1.0'
    ],
    'permissions' => [
        'some_permission' => 'Some permission'
    ],
    'models' => [
        'general' => [
            'id' => 'ID',
            'name' => 'Name',
            'short_name' => 'Short name',
            'description' => 'Description',
            'type' => 'Type',
            'image' => 'Image',
            'select' => 'Select',
            'select_existing' => 'Selected existing',
            'created_at_event' => 'Created At',
            'updated_at_event' => 'Updated At',
            'created_by_user' => 'Created By',
            'created_at' => 'Created At',
            'updated_at' => 'Updated At',
            'created_by' => 'Created By',
            'quantity' => 'Quantity',
            'distance' => 'Distance',
            'parent' => 'Parent',
            'actions' => 'Actions',
            'setup' => 'Setup',
            'reports' => 'Reports',
            '_qrcode' => 'QR Code',
            '_qrcode_scan' => 'QR Code Scan',
            'find_by_qrcode' => 'Find by QR code',
            'create' => 'Create',
            'new' => 'New',
            'add' => 'Add',
            'print' => 'Print',
            'save_and_print' => 'Save and Print',
            'correct_and_print' => 'Correct and Print',
            'response' => 'HTTP call response',
            'replication_debug' => 'Replication Debug',
            'trigger_http_call_response' => 'Trigger HTTP call response'
        ],
        'brand' => [
            'label' => 'Brand',
            'label_plural' => 'Brands',
            'image' => 'Image',
            '_actions' => ' Actions'
        ],
        'product' => [
            'label_plural' => 'Products',
            'label' => 'Product',
            'image' => 'Image',
            'model_name' => 'Model Name',
            '_actions' => ' Actions'
        ],
        'computerproduct' => [
            'label' => 'Computer Product',
            'label_plural' => 'Computer Products',
            'memory' => 'Memory',
            'HDD_size' => 'Hdd Size',
            'processor_version' => 'Processor Version',
            'processor_type' => 'Processor Type',
            '_actions' => ' Actions'
        ],
        'electronicproduct' => [
            'label' => 'Electronic Product',
            'label_plural' => 'Electronic Products',
            'voltage' => 'Voltage',
            '_actions' => ' Actions'
        ],
        'employee' => [
            'label' => 'Employee',
            'label_plural' => 'Employees',
            'user_role' => 'User Role',
            '_actions' => ' Actions'
        ],
        'person' => [
            'label' => 'Person',
            'label_plural' => 'People',
            'image' => 'Image',
            'last_transfer_location' => 'Last Transfer Location',
            'last_product_instance_location' => 'Last Product Instance Location',
            '_actions' => ' Actions'
        ],
        'transfer' => [
            'label' => 'Transfer',
            'label_plural' => 'Transfers',
            'pre_marked_arrived' => 'Pre Marked Arrived',
            'sent_at_event' => 'Sent At Event',
            'arrived_at_event' => 'Arrived At Event',
            '_actions' => ' Actions'
        ],
        'driver' => [
            'label' => 'Driver',
            'label_plural' => 'Drivers',
            '_actions' => ' Actions'
        ],
        'vehicle' => [
            'label' => 'Vehicle',
            'label_plural' => 'Vehicles',
            'registration' => 'Registration',
            'image' => 'Image',
            '_actions' => ' Actions'
        ],
        'productinstancetransfer' => [
            'label_plural' => 'Product Instance Transfer',
            'label' => 'Product Instance Transfer',
            '_actions' => ' Actions'
        ],
        'transferinvoice' => [
            'label_plural' => 'Transfer Invoice',
            'label' => 'Transfer Invoice',
            '_actions' => ' Actions'
        ],
        'transferpurchase' => [
            'label_plural' => 'Transfer Purchase',
            'label' => 'Transfer Purchase',
            '_actions' => ' Actions'
        ],
        'measurementunit' => [
            'label' => 'Measurement Unit',
            'label_plural' => 'Measurement Units',
            'short_name' => 'Short Name',
            'uses_quantity' => 'Uses Quantity',
            '_actions' => ' Actions'
        ],
        'offix' => [
            'label' => 'Offix',
            'label_plural' => 'Offices',
            '_actions' => ' Actions'
        ],
        'container' => [
            'label' => 'Container',
            'label_plural' => 'Containers',
            '_actions' => ' Actions'
        ],
        'productattribute' => [
            'label' => 'Product Attribute',
            'label_plural' => 'Product Attributes',
            'value' => 'Value',
            '_actions' => ' Actions'
        ],
        'productcategory' => [
            'label' => 'Product Category',
            'label_plural' => 'Product Categories',
            'parent_product_category' => 'Parent Product Category',
            'children' => 'Children',
            '_actions' => ' Actions'
        ],
        'productcategorytype' => [
            'label' => 'Product Category Type',
            'label_plural' => 'Product Category Types',
            '_actions' => ' Actions'
        ],
        'productsproductcategory' => [
            'label_plural' => 'Products Product Categories',
            'label' => 'Products Product Category',
            '_actions' => ' Actions'
        ],
        'productinstance' => [
            'label' => 'Product Instance',
            'label_plural' => 'Product Instances',
            'quantity' => 'Quantity',
            'external_identifier' => 'External Identifier',
            'asset_class' => 'Asset Class',
            'image' => 'Image',
            '_actions' => ' Actions'
        ],
        'vehicletype' => [
            'label' => 'Vehicle Type',
            'label_plural' => 'Vehicle Types',
            '_actions' => ' Actions'
        ],
        'warehouse' => [
            'label' => 'Warehouse',
            'label_plural' => 'Warehouses',
            '_actions' => ' Actions'
        ],
        'productproduct' => [
            'label_plural' => 'Product Products',
            'label' => 'Product Product',
            'sub_product' => 'Sub Product',
            'quantity' => 'Quantity',
            '_actions' => ' Actions'
        ],
        'supplier' => [
            'label' => 'Supplier',
            'label_plural' => 'Suppliers',
            '_actions' => ' Actions'
        ]
    ]
];