# Copyright 1999-2004 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-crypt/qca/qca-1.0.ebuild,v 1.3 2004/12/30 04:16:43 chriswhite Exp $

inherit eutils

DESCRIPTION="Qt Cryptographic Architecture (QCA)"
HOMEPAGE="http://delta.affinix.com/qca/"
SRC_URI="http://delta.affinix.com/qca//qca-${PV}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~x86 ~sparc ~ppc ~ia64 ~hppa"
IUSE=""

DEPEND=">=x11-libs/qt-3.3.0-r1
	>=dev-libs/openssl-0.9.6i"

src_unpack() {
	unpack ${A}
	cd ${S}
#	epatch ${FILESDIR}/qca-pathfix.patch || die "bad patch"
}

src_compile() {
	./configure --prefix=/usr || die "configure failed"
	sed -i \
		-e "/^CFLAGS/s:$: ${CFLAGS}:" \
		-e "/^CXXFLAGS/s:$: ${CXXFLAGS}:" \
		Makefile
	emake || die "emake failed"
}

src_install() {
	make INSTALL_ROOT="${D}" install || die "make install failed"
}
