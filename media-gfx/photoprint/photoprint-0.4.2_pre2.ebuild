# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-gfx/photoprint/photoprint-0.4.2_pre2.ebuild,v 1.3 2012/05/05 07:00:23 jdhore Exp $

EAPI=4

inherit eutils autotools

MY_P=${P/_/-}
DESCRIPTION="A utility for printing digital photographs"
HOMEPAGE="http://www.blackfiveimaging.co.uk/index.php?article=02Software%2F01PhotoPrint"
SRC_URI="http://www.blackfiveimaging.co.uk/photoprint/${MY_P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="cups"

RDEPEND="cups? ( net-print/cups )
	dev-libs/glib:2
	media-libs/lcms:0
	media-libs/netpbm
	media-libs/tiff
	>=net-print/gutenprint-5
	virtual/jpeg
	>=x11-libs/gtk+-2.4:2
	x11-libs/libX11
	x11-proto/xproto"
DEPEND="${RDEPEND}
	sys-devel/gettext
	virtual/pkgconfig"

S="${WORKDIR}/${MY_P}"

src_prepare() {
	epatch "${FILESDIR}"/${P}-cups-automagic.patch \
		"${FILESDIR}"/${P}-tests.patch \
		"${FILESDIR}"/${P}-underlinking.patch

	# Ships with po/Makefile.in.in from gettext-0.17
	# which fails with >=gettext-0.18
	cp "${EROOT}"/usr/share/gettext/po/Makefile.in.in po/

	eautoreconf
}

src_configure() {
	econf \
		$(use_enable cups)
}
