# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-mail/mlmmj/mlmmj-1.2.12.ebuild,v 1.5 2007/06/12 12:55:54 genone Exp $

inherit eutils

MY_PV="${PV/_rc/-RC}"
MY_P="${PN}-${MY_PV}"
DESCRIPTION="Mailing list managing made joyful"
HOMEPAGE="http://mlmmj.mmj.dk/"
SRC_URI="http://mlmmj.mmj.dk/files/${MY_P}.tar.bz2"
LICENSE="MIT"
SLOT="0"
KEYWORDS="amd64 ppc ~ppc-macos x86"
IUSE=""
DEPEND="virtual/mta"
#RDEPEND=""
S="${WORKDIR}/${MY_P}"
SHAREDIR="/usr/share/mlmmj"

src_compile() {
	econf
	emake || die
}

src_install() {
	make DESTDIR=${D} install || die

	dodir ${SHAREDIR}
	dodir ${SHAREDIR}/texts
	insinto ${SHAREDIR}/texts
	doins listtexts/*

	dodoc AUTHORS ChangeLog COPYING FAQ LICENSE README
	dodoc TODO TUNABLES UPGRADE VERSION README.access
	dodoc README.sendmail README.exim4 README.security

	insinto /usr/share/mlmmj
	cd ${S}/contrib/web
	doins -r *
}

pkg_postinst() {
	elog "mlmmj comes with serveral webinterfaces:"
	elog "- One for user subscribing/unsubscribing"
	elog "- One for admin tasks"
	elog "both available in a php and perl module."
	elog "For more info have a look in /usr/share/mlmmj"
}
