# Copyright 1999-2004 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-sci/elem/elem-1.0.3.ebuild,v 1.2 2004/06/24 21:57:14 agriffis Exp $

DESCRIPTION="periodic table of the elements"
HOMEPAGE="http://elem.sourceforge.net/"
SRC_URI="mirror://sourceforge/elem/${PN}-src-${PV}-Linux.tgz"
LICENSE="GPL-2"
KEYWORDS="~x86"
SLOT="0"
IUSE=""

DEPEND="virtual/x11
	virtual/glibc
	x11-libs/xforms"

src_compile () {
	emake all || die "Build failed."
}

src_install () {
	into /usr
	dobin elem elem-de elem-en
	dohtml -r doc/*
}

