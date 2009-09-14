# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-libs/aqbanking/aqbanking-4.1.4.ebuild,v 1.3 2009/09/14 19:46:44 swegener Exp $

EAPI="2"

inherit kde-functions

DESCRIPTION="Generic Online Banking Interface"
HOMEPAGE="http://www.aquamaniac.de/aqbanking/"
SRC_URI="http://www2.aquamaniac.de/sites/download/download.php?package=03&release=41&file=01&dummy=${P}.tar.gz -> ${P}.tar.gz"
LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~ppc64 ~sparc ~x86"
IUSE="chipcard debug kde ofx python qt3"
DEPEND=">=sys-libs/gwenhywfar-3.10.0.0
	>=app-misc/ktoblzcheck-1.14
	ofx? ( >=dev-libs/libofx-0.8.3 )
	chipcard? ( >=sys-libs/libchipcard-4.2.8 )
	qt3? ( =x11-libs/qt-3* )
	kde? ( >=kde-base/kdelibs-3.1.0 )"
RDEPEND="${DEPEND}"

MAKEOPTS="${MAKEOPTS} -j1"
RESTRICT="test"

src_configure() {
	KDEMAJORVER="3" set-kdedir

	local FRONTENDS="cbanking"
	(use qt3 || use kde) && FRONTENDS="${FRONTENDS} qbanking"
	use kde && FRONTENDS="${FRONTENDS} kbanking"

	local BACKENDS="aqhbci"
	use ofx && BACKENDS="${BACKENDS} aqofxconnect"

	econf PATH="/usr/qt/3/bin:${PATH}" \
		$(use_enable debug) \
		$(use_enable kde kde3) \
		$(use_enable python) \
		--with-frontends="${FRONTENDS}" \
		--with-backends="${BACKENDS}" \
		--with-docpath="/usr/share/doc/${PF}/apidoc"|| die "configure failed"
}

src_install() {
	make DESTDIR="${D}" install || die "install failed"
	rm -rf "${D}/usr/share/doc"
	dodoc AUTHORS README doc/* || die "dodoc failed"
	find "${D}" -name '*.la' -delete
}
