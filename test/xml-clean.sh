#!/bin/sh

tidy=/usr/local/bin/tidy
iconv=/usr/local/bin/iconv

$tidy -q -raw -asxml -f /dev/null --force-output 1 \
	--quote-nbsp 0 -bare -clean \
	| $iconv -c -f KOI8-RU -t UTF-8
