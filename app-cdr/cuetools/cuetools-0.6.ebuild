# Copyright 1999-2004 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-cdr/cuetools/cuetools-0.6.ebuild,v 1.2 2004/07/16 09:33:42 dholm Exp $

DESCRIPTION="Utilities to manipulate and convert .CUE- and .TOC-files"
HOMEPAGE="http://cuetools.sourceforge.net/"
SRC_URI="mirror://sourceforge/cuetools/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~x86 ~ppc"
IUSE=""

DEPEND=""

src_compile() {
	emake CFLAGS="${CFLAGS}" || die
}

src_install() {
	make \
		DESTDIR=${D} \
		prefix=/usr \
		mandir=/usr/share/man \
		install || die "install failed"
	dodoc README CHANGES
}
