# Copyright 1999-2004 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-misc/muttprint/muttprint-0.71.ebuild,v 1.10 2004/06/19 22:24:48 malc Exp $

DESCRIPTION="Script for pretty printing of your mails"
HOMEPAGE="http://muttprint.sf.net/"
SRC_URI="mirror://sourceforge/muttprint/${P}.tar.gz"

SLOT="0"
LICENSE="GPL-2"
KEYWORDS="x86 alpha ~amd64"
IUSE=""

DEPEND="virtual/tetex
	dev-perl/TimeDate"

src_compile() {

	if has_version 'app-text/ptex' ; then
		sed -i -e "s/latex/platex/g" muttprint
	fi
}

src_install() {
	make prefix=${D}/usr docdir=${D}/usr/share/doc docdirname=${P} install
}
