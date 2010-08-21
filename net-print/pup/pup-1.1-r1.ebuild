# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-print/pup/pup-1.1-r1.ebuild,v 1.1 2010/08/21 19:06:31 hwoarang Exp $

EAPI="2"

inherit eutils toolchain-funcs

MY_P=${P/-/_}

DESCRIPTION="Printer Utility Program, setup & maintenance for certain Lexmark & HP printers"
HOMEPAGE="http://pup.sourceforge.net/"
SRC_URI="mirror://sourceforge/pup/${MY_P}_src.tar.gz
	 http://alfter.us/files/${P}-manpage-install.patch.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
DEPEND="=x11-libs/gtk+-1.2*"
IUSE=""

S=${WORKDIR}/${MY_P}

src_prepare() {
	epatch ${DISTDIR}/${P}-manpage-install.patch.gz
	sed -i -e "/^CC/s: =.*$: = $(tc-getCC) ${CFLAGS} ${LDFLAGS}:" \
		Makefile || die "sed failed"
}

src_compile() {
	emake || die "emake failed"
}

src_install() {
	dodir /usr/share/man/man1
	make DESTDIR=${D} install || die
}
