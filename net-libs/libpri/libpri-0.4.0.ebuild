# Copyright 1999-2004 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-libs/libpri/libpri-0.4.0.ebuild,v 1.3 2004/05/10 13:04:47 dholm Exp $

IUSE=""

DESCRIPTION="Primary Rate ISDN (PRI) library"
HOMEPAGE="http://www.asterisk.org/"
SRC_URI="ftp://ftp.asterisk.org/pub/telephony/libpri/old/libpri-${PV}.tar.gz"

SLOT="0"
LICENSE="GPL-2"
KEYWORDS="~x86 ~ppc"

DEPEND="virtual/glibc"

src_compile() {
	emake || die
}

src_install() {
	make INSTALL_PREFIX=${D} install || die

	dodoc ChangeLog README TODO
}
