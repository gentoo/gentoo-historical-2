#!/bin/bash

if [ "${1}" ]; then
	ver=${1}
else
	ver=x86-1.4
fi

for x in `cat /usr/portage/profiles/default-${ver}/packages.build | grep -v '^#'`
do
	myp=$(grep -E "${x}(-[^[:space:]]*)?[[:space:]]*$" /usr/portage/profiles/default-${ver}/packages | grep -v '^#' | sed -e 's:^\*::' | cat )
	if [ "$myp" = "" ]
	then
		#if not in the system profile, include it anyway
		echo $x
	else
		echo $myp
	fi
done
