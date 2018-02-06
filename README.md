# EnvDevPHPBase

[![Build Status](https://travis-ci.org/vfalies/EnvDevPHPBase.svg?branch=master)](https://travis-ci.org/vfalies/EnvDevPHPBase)

EnvDevPHPBase is a PHP container designed to be used like a base for a utilisation into the [EnvDev project](https://vfac.fr/projects/envdev).
The utlisation outside this project is naturally possible.

## Images

Four PHP versions are available through image's tags:

- 5.6 
- 7.0 
- 7.1 
- 7.2 

The latest version of EnvDevPHPBase (latest) (`vfac/envdevphpbase`) is a image with the last version of PHP available.

Each versions exist in Alpine version to limit the image size.

## PHP Customization

To customize the PHP image you can share your `php.ini` file into `/usr/local/etc/php/php.ini` into your Dockerfile or docker-compose file.
A maximum of PHP extension have been added to be used in a maximum of projects.

## Usage

```
docker run -d --name php -p 9000:9000 -v $PWD:/var/www/html vfac/envdevphpbase:7.2
```

## Complements

### Maildev configuration

The maildev configuration has been added into this image to be used into the [EnvDev project](https://vfac.fr/projects/envdev).
There are no consequence if you use this image for an another utilisation.

### X-Debug

X-Debug is installed with standard options.
Two options have been customized: 
    - remote_enable=on
    - remote_autostart=off

Note: X-Debug is not yet available for PHP 7.2 alpine

### Composer

Composer (1.5.5) is installed to be used with your configuration of PHP.