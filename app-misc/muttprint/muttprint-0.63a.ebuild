# Copyright 1999-2003 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-misc/muttprint/muttprint-0.63a.ebuild,v 1.4 2003/09/19 16:18:15 usata Exp $

S=${WORKDIR}/${P}
DESCRIPTION="pretty printing of your mails"
HOMEPAGE="http://muttprint.sf.net/"
SRC_URI="mirror://sourceforge/muttprint/${P}.tar.gz"

SLOT="0"
LICENSE="GPL-2"
KEYWORDS="x86"

DEPEND="virtual/tetex"

src_compile() {

	if has_version 'app-text/ptex' ; then
		cp muttprint muttprint.in
		sed -e "s/latex/platex/g" muttprint.in > muttprint
	fi
}

src_install() {
	# understanding the install part of the Makefiles.
	make prefix=${D}/usr docdir=${D}/usr/share/doc/ install || die
}
