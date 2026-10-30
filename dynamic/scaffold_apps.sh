#!/bin/bash

# This script creates boilerplate Django app files for Maiden Crown Store

# Define base directory
APPS_DIR="/Users/danielg/Ark/pykesys-maiden-crown-web/dynamic/apps"

# Helper function to create app config
create_app_config() {
    local app_name=$1
    local class_name=$(echo $app_name | sed -r 's/(^|_)([a-z])/\U\2/g')Config
    
    cat > "$APPS_DIR/$app_name/apps.py" << EOF
from django.apps import AppConfig


class ${class_name}(AppConfig):
    default_auto_field = 'django.db.models.BigAutoField'
    name = 'apps.${app_name}'
EOF
}

# Create apps.py for each app
create_app_config "products"
create_app_config "orders"
create_app_config "content_api"
create_app_config "digital_delivery"

echo "App configs created successfully!"
