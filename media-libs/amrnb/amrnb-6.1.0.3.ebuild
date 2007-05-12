# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-libs/amrnb/amrnb-6.1.0.3.ebuild,v 1.1 2007/05/12 16:40:14 beandog Exp $

WANT_AUTOCONF="latest"
WANT_AUTOMAKE="latest"

inherit eutils autotools

SPEC_VER="26104-610"

DESCRIPTION="Wrapper library for 3GPP Adaptive Multi-Rate Floating-point Speech Codec"
HOMEPAGE="http://www.penguin.cz/~utx/amr"
SRC_URI="http://ftp.penguin.cz/pub/users/utx/amr/${P}.tar.bz2
	http://www.3gpp.org/ftp/Specs/archive/26_series/26.104/${SPEC_VER}.zip"
RESTRICT="mirror"
LICENSE="LGPL-2 as-is"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""
DEPEND="app-arch/unzip"

src_unpack() {
	unpack ${P}.tar.bz2
	cd ${S}
	cp "${DISTDIR}/${SPEC_VER}.zip" .
}

src_compile() {
	econf || die "econf failed"
	emake || die "emake failed"
}

src_install() {
	emake DESTDIR="${D}" install || die "emake install failed"
	dodoc AUTHORS ChangeLog NEWS README TODO
}
