# Copyright 1999-2004 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sys-libs/chipcard-client/chipcard-client-1.9.4_beta.ebuild,v 1.3 2004/12/27 01:31:20 kloeri Exp $

inherit eutils

DESCRIPTION="2nd generation of the chipcard-reader-utility (client)"
HOMEPAGE="http://www.libchipcard.de"
SRC_URI="mirror://sourceforge/libchipcard/chipcard2_client-${PV/_/}.tar.gz"
LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~x86 ~sparc ~alpha"

IUSE="debug ssl"

DEPEND="ssl? ( >=dev-libs/openssl-0.9.6b )
		sys-libs/gwenhywfar"

S=${WORKDIR}/chipcard2_client-${PV/_/}

src_compile() {

	econf \
	`use_enable ssl` \
	`use_enable debug` \
	|| die

	emake || die
}

src_install() {
	einstall || die
	dodoc AUTHORS ChangeLog COPYING
	insinto /etc/chipcard2-client/
	doins ${S}/doc/chipcardc2.conf.example
	cp ${D}/etc/chipcard2-client/chipcardc2.conf.example \
		${D}/etc/chipcard2-client/chipcardc2.conf
}
