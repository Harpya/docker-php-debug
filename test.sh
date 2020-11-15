#!/usr/bin/env bash

export HAS_PHALCON=$(php -i | grep "phalcon => enabled" | awk "BEGIN {ok=0;} /phalcon/ {ok=1} END { print ok; }"  )
export HAS_PSR=$(php -i | awk "BEGIN {ok=0;} /psr/ {ok=1} END { print ok; }"  )
export HAS_PGSQL=$(php -i | awk "BEGIN {ok=0;} /pdo_pgsql/ {ok=1} END { print ok; }"  )

if [ "$HAS_PHALCON" = "0" ]
then
    echo "Phalcon is not enabled"
    exit 1;
fi

if [ "$HAS_PSR" = "0" ]
then
    echo "PSR is not enabled"
    exit 1;
fi

if [ "$HAS_PGSQL" = "0" ]
then
    echo "PDO pgsql is not enabled"
    exit 1;
fi
