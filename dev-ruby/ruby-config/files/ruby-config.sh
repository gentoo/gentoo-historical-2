#!/bin/bash

# Copyright 1999-2004 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-ruby/ruby-config/files/ruby-config.sh,v 1.1 2004/01/29 18:02:15 usata Exp $

# Author: Mamoru KOMACHI <usata@gentoo.org>

if [ -z "${PORTDIR}" ] ; then
	[ -r /etc/make.conf ] && source /etc/make.conf
	if [ -z "${PORTDIR}" ] ; then
		[ -r /etc/make.globals ] && source /etc/make.globals
	fi
fi

if [ -r /etc/init.d/functions.sh ] ; then
	source /etc/init.d/functions.sh
else
	echo "Could not find /etc/init.d/functions.sh"
	exit 1
fi

#dummy function
EXPORT_FUNCTIONS() { :; }

if [ -r ${PORTDIR:-/usr/portage}/eclass/alternatives.eclass ] ; then
	source ${PORTDIR:-/usr/portage}/eclass/alternatives.eclass
else
	echo "Could not find ${PORTDIR:-/usr/portage}/bin/ebuild.sh"
	exit 1
fi

usage() {
cat << "USAGE_END"
Usage: ruby-config [Option] [Ruby Profile]
Change the current ruby profile, or give info about profiles.

Options:

  -c, --get-current-profile
                         Print current used ruby profile.
  -l, --list-profiles
                         List available ruby profiles.
  -h, --show-help
                         Print this help.

The profile name is either ruby16, ruby18 or ruby19.

USAGE_END
exit 1
}

if [ "$#" -lt 1 ] ; then
	usage
fi

switch_profile() {
	if [ "$EUID" != 0 ] ; then
		eerror "You need root privilege to switch profile."
		exit 1
	fi
	if [ -x /usr/bin/"$1" -a "$1" != "ruby" ] ; then
		local suf=${1/ruby/}
		for i in ruby irb erb testrb rdoc ri ; do
			alternatives_makesym \
				/usr/bin/$i /usr/bin/$i{$suf,18,16,19}
		done
		alternatives_makesym \
			/usr/lib/libruby.so /usr/lib/libruby{$suf,18.16,19}.so
		alternatives_makesym \
			/usr/share/man/man1/ruby.1.gz \
			/usr/share/man/man1/ruby{$suf,18,16,19}.1.gz
	else
		eerror "Unsupported profile."
	fi
}

get_current_profile() {
	if [ ! -L /usr/bin/ruby ] ; then
		eerror "Your ruby doesn't seem to support SLOT."
		exit 1
	fi
	einfo "Your current profile refers to $(readlink /usr/bin/ruby)."
}

list_profiles() {
	einfo "Supported profiles are:"
	for f in /usr/bin/ruby[0-9][0-9] ; do
		einfo "\t${f#/usr/bin/}"
	done
	einfo "You can specify one of the profiles listed above."
	einfo "e.g.) ruby-config ruby16"
}

for x in $* ; do
	if [ "$#" -gt 1 ] ; then
		eerror "ruby-config accepts only one argument."
		eerror "Run $0 -h for help."
		exit 1
	fi
	case "${x}" in
		-c|--get-current-profile)
			get_current_profile 
			;;
		-h|--show-help)
			usage
			;;
		-l|--list-profiles)
			list_profiles
			;;
		-*)
			eerror "Invalid option. Run $0 -h for help."
			exit 1
			;;
		*)
			switch_profile $*
			;;
	esac

	exit 0
done
