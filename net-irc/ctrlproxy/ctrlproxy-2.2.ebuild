# Copyright 1999-2003 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-irc/ctrlproxy/ctrlproxy-2.2.ebuild,v 1.4 2003/07/13 12:54:50 aliz Exp $

MY_P="${PN}_2.2-2"
DESCRIPTION="IRC proxy with multiserver and multiclient support"
HOMEPAGE="http://people.nl.linux.org/~jelmer/ctrlproxy.php"
SRC_URI="http://people.nl.linux.org/~jelmer/${PN}/${MY_P}.tar.gz"
LICENSE="GPL-2"

SLOT="0"
KEYWORDS="~alpha x86"
IUSE=""
DEPEND=">=dev-libs/glib-2"

S=${WORKDIR}/${PN}

src_compile() {
	emake PREFIX=/usr CC="${CC} ${CFLAGS}" || die
}

src_install() {
	make install DESTDIR=${D} PREFIX=/usr DOCDIR=/usr/share/doc/${P} || die
	gzip ${D}/usr/share/doc/*/*
	dodoc ctrlproxyrc.example
}
