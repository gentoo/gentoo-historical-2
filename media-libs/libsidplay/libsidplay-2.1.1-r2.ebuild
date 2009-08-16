# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-libs/libsidplay/libsidplay-2.1.1-r2.ebuild,v 1.6 2009/08/16 14:26:48 armin76 Exp $

EAPI=2
inherit eutils libtool

MY_P=sidplay-libs-${PV}

DESCRIPTION="C64 SID player library"
HOMEPAGE="http://sidplay2.sourceforge.net/"
SRC_URI="mirror://sourceforge/sidplay2/${MY_P}.tar.gz"

LICENSE="GPL-2"
SLOT="2"
KEYWORDS="alpha amd64 hppa ia64 ~mips ppc ~ppc64 sparc x86 ~x86-fbsd"
IUSE=""

RDEPEND=""
DEPEND=""

S=${WORKDIR}/${MY_P}

src_prepare() {
	epatch "${FILESDIR}"/libsidplay2-gcc41.patch \
		"${FILESDIR}"/${P}-fbsd.patch \
		"${FILESDIR}"/${P}-gcc43.patch
	elibtoolize
}

src_configure() {
	econf \
		--enable-shared \
		--with-pic
}

src_install() {
	emake DESTDIR="${D}" install || die "emake install failed"

	cd "${S}"/libsidplay
	docinto libsidplay
	dodoc AUTHORS ChangeLog README TODO

	cd "${S}"/libsidutils
	docinto libsidutils
	dodoc AUTHORS ChangeLog README TODO

	cd "${S}"/resid
	docinto resid
	dodoc AUTHORS ChangeLog NEWS README THANKS TODO

	doenvd "${FILESDIR}"/65resid
}
