# Copyright 1999-2000 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License, v2 or later
# Author Dan Armak <danarmak@gentoo.org>
# $Header: /var/cvsroot/gentoo-x86/eclass/base.eclass,v 1.9 2002/01/04 12:06:28 danarmak Exp $
# The base eclass defines some default functions and variables. Nearly everything
# else inherits from here.
ECLASS=base

S=${WORKDIR}/${P}
DESCRIPTION="Based on the $ECLASS eclass"

base_src_unpack() {

	debug-print-function $FUNCNAME $*
	[ -z "$1" ] && base_src_unpack all

	while [ "$1" ]; do

	case $1 in
		unpack)
			debug-print-section unpack
			unpack ${A}
			;;
	    patch)
			debug-print-section patch
			cd ${S}
			patch -p0 < ${FILESDIR}/${P}-gentoo.diff
			;;
	    all)
			debug-print-section all
			base_src_unpack unpack
			;;
		esac

	shift
	done
    
}

base_src_compile() {

	debug-print-function $FUNCNAME $*
    [ -z "$1" ] && base_src_compile all

    while [ "$1" ]; do

	case $1 in
	    configure)
		debug-print-section configure
		./configure || die
		;;
	    make)
		debug-print-section make
		make || die
		;;
	    all)
		debug-print-section all
		base_src_compile configure make
		;;
	esac
	
    shift
    done
    
}

base_src_install() {

	debug-print-function $FUNCNAME $*
	[ -z "$1" ] && base_src_install all

	while [ "$1" ]; do

	case $1 in
		make)
			debug-print-section make
			make DESTDIR=${D} install || die
			;;
	    all)
			debug-prnit-section all
			base_src_install make
			;;
	esac

	shift
	done

}

EXPORT_FUNCTIONS src_unpack src_compile src_install

# misc helper functions
# adds all parameters to DEPEND and RDEPEND
newdepend() {

	debug-print-function newdepend $*
	debug-print "newdepend: DEPEND=$DEPEND RDEPEND=$RDEPEND"

	while [ -n "$1" ]; do
		DEPEND="$DEPEND $1"
		RDEPEND="$RDEPEND $1"
		shift
	done

}

