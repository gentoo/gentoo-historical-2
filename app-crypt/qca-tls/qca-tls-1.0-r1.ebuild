# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-crypt/qca-tls/qca-tls-1.0-r1.ebuild,v 1.6 2005/01/18 14:09:40 gustavoz Exp $

inherit eutils

DESCRIPTION="plugin to provide SSL/TLS capability to programs that utilize the Qt Cryptographic Architecture (QCA)"
HOMEPAGE="http://delta.affinix.com/qca/"
SRC_URI="http://delta.affinix.com/qca/${PN}-${PV}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
#alpha amd64 and ppc64 need testing
KEYWORDS="~amd64 ~hppa ~ia64 ~ppc sparc x86"
IUSE=""

DEPEND=">=app-crypt/qca-1.0
	>=x11-libs/qt-3.3.0-r1
	>=dev-libs/openssl-0.9.6i"

src_unpack() {
	unpack ${A}
	cd ${S}
	epatch ${FILESDIR}/qca-pathfix.patch || die "bad patch"
}

src_compile() {
	./configure || die "configure failed"
	sed -i \
		-e "/^CFLAGS/s:$: ${CFLAGS}:" \
		-e "/^CXXFLAGS/s:$: ${CXXFLAGS}:" \
		Makefile
	emake || die "emake failed"
}

src_install() {
	make INSTALL_ROOT="${D}" install || die "make install failed"
	insinto /usr/include
	doins qca-tls.h

	dodoc README
}
