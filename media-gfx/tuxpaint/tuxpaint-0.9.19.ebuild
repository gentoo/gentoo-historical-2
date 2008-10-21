# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-gfx/tuxpaint/tuxpaint-0.9.19.ebuild,v 1.3 2008/10/21 20:25:04 gentoofan23 Exp $

inherit eutils gnome2-utils multilib

DESCRIPTION="Drawing program designed for young children"
HOMEPAGE="http://www.tuxpaint.org/"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ~ppc ~x86"

IUSE="nls svg"

DEPEND="media-libs/libsdl
	media-libs/sdl-image
	media-libs/sdl-ttf
	media-libs/sdl-mixer
	media-libs/sdl-pango
	>=media-libs/libpng-1.2
	>=media-libs/freetype-2
	app-text/libpaper
	nls? ( sys-devel/gettext )
	svg? (
		gnome-base/librsvg
		x11-libs/cairo )"

src_unpack() {
	unpack ${A}
	cd "${S}"

	# Sanitize the Makefile and correct a few other issues.
	epatch "${FILESDIR}/${P}-gentoo.patch"
	epatch "${FILESDIR}/${P}-libpng.patch"

	# Make multilib-strict compliant, see bug #200740
	sed -i -e "s:/GET_LIBDIR/:/$(get_libdir)/:" Makefile || die "sed failed"
}

src_compile() {
	local myopts=""

	use nls && myopts="${myopts} ENABLE_GETTEXT=1"
	use svg || myopts="${myopts} nosvg"

	# emake may break things
	make ${myopts} || die "Compilation failed"
}

src_install () {
	local myopts=""

	use nls && myopts="${myopts} ENABLE_GETTEXT=1"

	make PKG_ROOT="${D}" ${myopts} install || die "Installation failed"

	rm -f docs/COPYING.txt docs/INSTALL.txt
	dodoc docs/*.txt
}

pkg_postinst() {
	gnome2_icon_cache_update

	elog ""
	elog "For additional graphic stamps, you can emerge the"
	elog "media-gfx/tuxpaint-stamps package."
	elog ""
}
