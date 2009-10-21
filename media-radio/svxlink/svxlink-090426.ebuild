# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-radio/svxlink/svxlink-090426.ebuild,v 1.2 2009/10/21 16:07:24 maekke Exp $

EAPI=1

inherit kde-functions

DESCRIPTION="Multi Purpose Voice Services System, including Qtel for EchoLink"
HOMEPAGE="http://svxlink.sourceforge.net/"
SRC_URI="mirror://sourceforge/svxlink/${P}.tar.gz"

LICENSE="GPL-2 LGPL-2.1"
SLOT="0"
KEYWORDS="x86"
IUSE=""

RDEPEND="dev-lang/tcl
	media-sound/gsm
	x11-libs/qt:3
	dev-libs/libgcrypt
	media-libs/speex
	dev-libs/libsigc++:1.2
	dev-libs/popt"
DEPEND="${RDEPEND}
	dev-util/pkgconfig"

src_unpack() {
	unpack ${A}
	cd "${S}"
	epatch "${FILESDIR}/${PN}-080730--as-needed.patch"
	epatch "${FILESDIR}/${P}-gcc44.patch"
}

src_compile() {
	set-kdedir
	emake -j1 || die "emake failed"
}

src_install() {
	emake -j1 \
		INSTALL_ROOT="${D}" \
		install || die "emake install failed"
}
