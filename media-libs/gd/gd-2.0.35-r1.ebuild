# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-libs/gd/gd-2.0.35-r1.ebuild,v 1.11 2010/05/21 10:34:08 ssuominen Exp $

EAPI=1
inherit autotools

DESCRIPTION="A graphics library for fast image creation"
HOMEPAGE="http://libgd.org/"
SRC_URI="http://libgd.org/releases/${P}.tar.bz2"

LICENSE="|| ( as-is BSD )"
SLOT="2"
KEYWORDS="alpha amd64 arm hppa ia64 m68k ~mips ppc ppc64 s390 sh sparc x86 ~sparc-fbsd ~x86-fbsd"
IUSE="fontconfig jpeg png truetype xpm"

RDEPEND="fontconfig? ( media-libs/fontconfig )
	jpeg? ( >=media-libs/jpeg-6b:0 )
	png? ( >=media-libs/libpng-1.2.43-r2:0
		sys-libs/zlib )
	truetype? ( >=media-libs/freetype-2.1.5 )
	xpm? ( x11-libs/libXpm x11-libs/libXt )"
DEPEND="${RDEPEND}"

src_unpack() {
	unpack ${A}
	cd "${S}"
	epatch "${FILESDIR}"/${P}-libpng14.patch \
		"${FILESDIR}"/${P}-maxcolors.patch

	# Try libpng14 first, then fallback to plain libpng
	sed -i \
		-e 's/libpng12-config/libpng14-config/g' \
		-e 's/-lpng12/-lpng14/' \
		configure.ac || die

	eautoconf
	find . -type f -print0 | xargs -0 touch -r configure
}

src_compile() {
	econf \
		$(use_with fontconfig) \
		$(use_with png) \
		$(use_with truetype freetype) \
		$(use_with jpeg) \
		$(use_with xpm) \
		|| die
	emake || die
}

src_install() {
	emake DESTDIR="${D}" install || die
	dodoc INSTALL README*
	dohtml -r ./
}
