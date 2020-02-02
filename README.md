## Supported tags and respective Dockerfile

This dockerfile is only support php5.2 apache environment.

Only latest tag is available.


## Why legacy php5.2 apache environment

For Engineers struggling legacy php environement.
PHP is light weight scripting languege which need to build from source, except using binrary code.
For building php, it strongly depends on architecture, for example 32bit or 64bit, and kernel.

## AWS provide powerfull deployment tools

Enginner's life quality is improved, if php application is deployed via container.

## php5.2 apache

Most of lagacy php5.2 product is used with apache.
I decided to choose php5.2 with apache, not php5.2 cli, nor php-fpm.


##  php-build and phpenv

[phpenv](https://github.com/phpenv/phpenv) is php installing tools for developer.
It's really easy to use.

We also use [php-bulid](https://github.com/php-build/php-build) for phpevn plugin.


## Directory structure is here

```
.
└── config
    ├── apache
    │   ├── conf
    │   ├── conf.d
    │   └── conf.modules.
    └── php-build
        ├── after-install
        ├── before-instal
        ├── definitions
        ├── extension
        ├── patches
        └── plugins.ds
```

### Apache Configuration ./config/apache

This config file is used for apache runtime configuration.
If you want change apache config setting, change these files.
Root configuration is ./config/apache/conf/httpd.conf.

This configuration is copied from amazonlinux2 default apache configuration using docker copy command.

I changed a little bit for executing php.

```./config/apache/conf/httpd.conf
<FilesMatch \.php$>
    SetHandler application/x-httpd-php
</FilesMatch>
```

### php-build Configuration ./config/php-build

This config file is used for php-build configuration.
If you want change php-build config setting, change these files.
For details, Please read php-build manual.

For amazonlinux2, we add 2 patche files.

1. ./config/php-build/patches/01php-5.2.17.patch
2. ./config/php-build/before-install.d/sed_unixd.sh

I applied patch file.

```./config/php-build/definitions
patch_file "01php-5.2.17.patch"
```

I wrote shellscript './config/php-build/before-install.d/sed_unixd.sh' this is do the same responsibility with patch file but not patch file, because I just don't know how to create patch and patch files executing order! Sorry.


### installing php extensions

please add file database.

```config/php-build/extension/definition
"name","url-dist","url_source","source_cwd","configure_args","extension_type","after_install"
"apc","http://pecl.php.net/get/APC-$version.tgz","git@git.php.net:/pecl/caching/apc.git",,"--enable-apc","extension",
"apcu","http://pecl.php.net/get/apcu-$version.tgz","https://github.com/krakjoe/apcu.git",,,"extension",
"igbinary","http://pecl.php.net/get/igbinary-$version.tgz","https://github.com/igbinary/igbinary.git",,,"extension",
"imagick","http://pecl.php.net/get/imagick-$version.tgz","https://github.com/mkoppanen/imagick.git",,,"extension",
"memcache","http://pecl.php.net/get/memcache-$version.tgz","git@git.php.net:/pecl/caching/memcache.git",,,"extension",
"memcached","http://pecl.php.net/get/memcached-$version.tgz","https://github.com/php-memcached-dev/php-memcached.git",,"--disable-memcached-sasl","extension",
"uprofiler",,"https://github.com/FriendsOfPHP/uprofiler.git","extension",,"extension","uprofiler_after_install"
"xcache","http://xcache.lighttpd.net/pub/Releases/$version/xcache-$version.tar.gz",,,"--enable-xcache","extension",
"xdebug","http://xdebug.org/files/xdebug-$version.tgz","git://github.com/xdebug/xdebug.git",,"--enable-xdebug","zend_extension","xdebug_after_install"
"xhprof","http://pecl.php.net/get/xhprof-$version.tgz","git://github.com/facebook/xhprof.git",,,"extension","xhprof_after_install"
"zendopcache","http://pecl.php.net/get/zendopcache-$version.tgz","https://github.com/zendtech/ZendOptimizerPlus.git",,"--enable-opcache","zend_extension","zendopcache_after_install"
```

and relating specific version of php5.2 build definitions like below.

``` config/php-build/definitions/5.2.17
install_xdebug "2.2.7"
```

## I confirmed to work php extensions

pecl [yaml, oci8, oci-postgres, oci-oracle]

## php configuration reference

[phpinfo](./phpinfo().html)
