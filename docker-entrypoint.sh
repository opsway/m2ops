#!/bin/bash
set -e

echo "Initializing setup..."

cd /var/www/html

if [ -f ./app/etc/config.php ] || [ -f ./app/etc/env.php ]; then
  echo "It appears Magento is already installed (app/etc/config.php or app/etc/env.php exist). Trigger redeploy..."
  php ./bin/magento cache:clean
  exit
fi

echo "Running Magento 2 setup script..."
php ./bin/magento setup:install \
  --db-host=$M2SETUP_DB_HOST \
  --db-name=$M2SETUP_DB_NAME \
  --db-user=$M2SETUP_DB_USER \
  --db-password=$M2SETUP_DB_PASSWORD \
  --base-url=$M2SETUP_BASE_URL \
  --admin-firstname=Admin \
  --admin-lastname=Support \
  --admin-email=support@opsway.com \
  --admin-user=$M2SETUP_ADMIN_USER \
  --admin-password=$M2SETUP_ADMIN_PASSWORD \
  --use-sample-data --use-rewrites=1 --currency=USD --timezone=UTC --language=en_US --backend-frontname=admin

echo "The setup script has completed execution."

php ./setup.php
echo "Setup Redis storage"

n98-magerun2.phar config:set "dev/static/sign" 0
n98-magerun2.phar config:set "dev/css/merge_css_files" 1
n98-magerun2.phar config:set "dev/css/minify_files" 1
n98-magerun2.phar config:set "dev/js/merge_files" 1
n98-magerun2.phar config:set "dev/js/enable_js_bundling" 1
n98-magerun2.phar config:set "dev/js/minify_files" 1

php ./bin/magento deploy:mode:set production
php ./bin/magento cache:clean

exec "$@"