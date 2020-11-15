#!/usr/bin/env bash

if [ -z $1 ];
then
        VERSION="0.0.1"
else
        VERSION="$1"
fi

docker build --tag harpya/php-debug:${VERSION} .