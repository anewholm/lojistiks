<?php return [
    'plugin' => [
        'name' => 'Lojistiks',
        'actions' => 'Logistiks',
        'product_instances' => 'Inventory',
        'inventory' => 'Inventory',
        'setup' => 'Setup',
        'reports' => 'Reports',
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
        'suppliers' => 'External Suppliers',
        'transfers' => 'Transfers',
        'vehicles' => 'Vehicles',
        'replication_debug' => 'Replication Debug',
        'trigger_http_call_response' => 'Trigger HTTP call response'
    ],
    'models' => [
        'general' => [
            'id' => 'ID',
            'or' => 'Or',
            'centre_id' => 'Centre ID',
            'leaf_id' => 'Leaf ID',
            'name' => 'Name',
            'qrcode_name' => 'QR Code name',
            'type' => 'Type',
            'image' => 'Image',
            'select' => 'Select',
            'created_at' => 'Created At',
            'updated_at' => 'Updated At',
            'scan_qrcode' => 'Scan A QRCode',
            'find_by_qrcode' => 'Find by QRCode',
            'save_and_print' => 'Save and Print',
            'correct_and_print' => 'Save correction and print',
            'print' => 'Print',
            'user_group' => 'Group',
            'user' => 'Person',
            'from_user_group' => 'From Group'
        ],
        'product' => [
            'label' => 'Product Type',
            'label_plural' => 'Product Types',
            'model' => 'Model',
            'external_identifier' => 'Serial number',
            'asset_class' => 'Asset Class'
        ],
        'measurementunit' => [
            'label' => 'Measurement Unit',
            'label_plural' => 'Measurement Units',
            'uses_quantity' => 'Uses Quantity',
            'short_name' => 'Short Name'
        ],
        'brand' => [
            'label' => 'Brand',
            'label_plural' => 'Brands',
            'select' => 'Select an existing Brand',
            'create' => 'Create a new Brand',
            'new' => 'New Brand'
        ],
        'productinstance' => [
            'label' => 'Inventory',
            'label_plural' => 'Inventory',
            'create_product_instances' => 'Register Inventory',
            'quantity' => 'Quantity'
        ],
        'office' => [
            'label' => 'Office',
            'label_plural' => 'Offices'
        ],
        'warehouse' => [
            'label' => 'Warehouse',
            'label_plural' => 'Warehouses'
        ],
        'computerproduct' => [
            'label' => 'Computer Product Type',
            'label_plural' => 'Computer Product Types',
            'memory' => 'Memory',
            'hdd_size' => 'HDD Size',
            'processor_type' => 'Processor Type',
            'processor_version' => 'Processor Version'
        ],
        'electronicproduct' => [
            'label' => 'Electronic Product Type',
            'label_plural' => 'Electronic Product Types'
        ],
        'person' => [
            'label' => 'Person',
            'label_plural' => 'People',
            'first_name' => 'First Name',
            'last_name' => 'Last Name',
            'login' => 'Login',
            'email' => 'Email',
            'password' => 'Password'
        ],
        'supplier' => [
            'label' => 'External Supplier',
            'label_plural' => 'External Suppliers'
        ],
        'transfer' => [
            'label' => 'Transfer',
            'label_plural' => 'All Transfers',
            'transfer_inventory' => 'Transfer Inventory Units',
            'transfer_quantity' => 'Transfer Quantites',
            'add_product_instance' => 'Add existing Inventory (Units)',
            'add_product' => 'Add Quantity based Product Types (Litres, Kilograms)',
            'add' => 'Add',
            'pi_section' => 'Product Instances in the transfer',
            'pi_section_comment' => 'Scan inventory QR codes to add to the list, ot add them manually below',
            'dates' => 'Dates',
            'arrived_at' => 'Arrived at',
            'arrived_at_comment' => 'Inventory, vehicle and driver will not appear at destination until arrived at date is completed',
            'sent_at' => 'Sent at',
            'pre_marked_arrived' => 'Mark as arrived',
            'pre_marked_arrived_comment' => 'No confirmation or date is required',
            'quantity' => 'Quantity',
            'product_instance_count' => 'Inventory count',
            'product_instance_quantity' => 'Quantity',
            'product_instance_contents' => 'Contents',
            'product_contents' => 'Product Contents',
            'send_and_print' => 'Send and Print',
            'send' => 'Send',
            'send_and_close' => 'Send and Close',
            'correct_and_print' => 'Save correction and print',
            'source_location' => 'Source Location',
            'destination_location' => 'Destination Location',
            'transfers_in' => 'Transfers In',
            'transfers_out' => 'Transfers Out',
            'distance' => 'Distance'
        ],
        'vehicle' => [
            'label' => 'Vehicle',
            'label_plural' => 'Vehicles',
            'registration' => 'Registration',
            'transport' => 'Transport'
        ],
        'employee' => [
            'label' => 'Employee',
            'label_plural' => 'Employees'
        ],
        'driver' => [
            'label' => 'Driver',
            'label_plural' => 'Drivers'
        ],
        'vehicletype' => [
            'label' => 'Type',
            'label_plural' => 'Vehicle Types'
        ],
        'oilproduct' => [
            'label' => 'Oil Product',
            'label_plural' => 'Oil Products',
            'purity' => 'Purity',
            'octain_content' => 'Octain Content'
        ],
        'stockproduct' => [
            'label' => 'Product Type Inventory',
            'label_plural' => 'Product Type Inventories'
        ],
        'stock' => [
            'label' => 'Inventory',
            'label_plural' => 'Inventories'
        ],
        'location' => [
            'address' => 'Address',
            'latitude' => 'Latitude',
            'longitude' => 'Longitude',
            'parent' => 'Containing facility',
            'create_area' => 'Create area >>',
            'add_gps' => 'Set GPS >>',
            'label' => 'Facility',
            'label_plural' => 'All Facilities',
            'initial_location' => 'Initial Facility'
        ],
        'lookup' => [
            'label' => 'Lookup',
            'label_plural' => 'Lookups',
            'address' => 'Address',
            'google_address' => 'Lookup on Google Maps',
            'vicinity' => 'Vicinity',
            'city' => 'City',
            'postalcode' => 'Postal Code',
            'zip' => 'Postal Code',
            'country_code' => 'Country Code',
            'state_code' => 'State Code',
            'latitude' => 'Latitude',
            'longitude' => 'Longitude'
        ],
        'area' => [
            'label' => 'Area',
            'label_plural' => 'Areas',
            'parent' => 'Containing Area'
        ],
        'address' => [
            'label' => 'Address',
            'label_plural' => 'Addresses',
            'number' => 'Number',
            'street' => 'Street',
            'longitude' => 'Longitude',
            'latitude' => 'Latitude',
            'auto_location' => 'Create an associated Location',
            'select_existing' => 'Select an existing Address'
        ],
        'gps' => [
            'label' => 'GPS',
            'label_plural' => 'GPSs',
            'longitude' => 'Longitude',
            'latitude' => 'Latitude'
        ],
        'areatype' => [
            'label' => 'Area Type',
            'label_plural' => 'Area Types'
        ]
    ]
];