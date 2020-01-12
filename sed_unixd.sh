#!/usr/bin/env bash
sed -i -e "s/unixd_config/ap_unixd_config/g" $SOURCE_PATH/sapi/apache2handler/php_functions.c
sed -i -e "s/ap_unixd_config_rec/unixd_config_rec/g" $SOURCE_PATH/sapi/apache2handler/php_functions.c
