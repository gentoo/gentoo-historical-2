# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/eclass/emul-libs.eclass,v 1.1 2007/02/21 09:08:20 blubb Exp $

#
# Original Author: Simon Stelling <blubb@gentoo.org>
# Purpose: Providing a template for the app-emulation/emul-linux-* packages 
#

EXPORT_FUNCTIONS src_unpack src_install

DESCRIPTION="Provides precompiled 32bit libraries"
HOMEPAGE="http://amd64.gentoo.org/emul/content.xml"

RESTRICT="strip"
S=${WORKDIR}

SLOT="0"
IUSE=""

emul-libs_src_unpack() {
	einfo "Note: You can safely ignore the 'trailing garbage after EOF'"
	einfo "      warnings below"
	
	unpack ${A}
	cd "${S}"
	
	ALLOWED=${ALLOWED:-^${S}/etc/env.d}
	find "${S}" ! -type d ! -name '*.so*' | egrep -v "${ALLOWED}" | xargs -d $'\n' rm -f || die 'failed to remove everything but *.so*'
}

emul-libs_src_install() {
	for dir in etc/env.d etc/revdep-rebuild ; do
		if [[ -d "${S}"/${dir} ]] ; then
			for f in "${S}"/${dir}/* ; do
				mv -f "$f"{,-emul}
			done
		fi
	done

	# remove void directories
	find "${S}" -print0 -depth -type d | xargs -0 rmdir 2&>/dev/null

	cp -dpPR "${S}"/* "${D}"/ || die "copying files failed!"
}
