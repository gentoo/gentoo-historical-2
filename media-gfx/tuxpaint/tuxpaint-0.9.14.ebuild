# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-gfx/tuxpaint/tuxpaint-0.9.14.ebuild,v 1.3 2005/04/19 09:09:57 leonardop Exp $

inherit eutils

DESCRIPTION="Drawing program designed for young children"
HOMEPAGE="http://www.newbreedsoftware.com/tuxpaint/"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="x86 ~ppc ~amd64"

IUSE="gnome kde nls"

DEPEND="media-libs/libpng
	media-libs/sdl-ttf
	media-libs/sdl-mixer
	media-libs/sdl-image
	media-libs/libsdl
	>=media-libs/freetype-2
	media-libs/netpbm
	nls? ( sys-devel/gettext )"

src_unpack() {
	unpack ${A}
	cd ${S}

	find . -name CVS | xargs rm -rf
	# Sanitize the Makefile and correct a few other issues.
	epatch ${FILESDIR}/${P}-gentoo.patch
}

src_compile() {
	local myopts=""

	use nls && myopts="${myopts} ENABLE_GETTEXT=1"

	# emake may break things
	make ${myopts} || die
}

src_install () {
	local myopts=""

	use gnome && myopts="${myopts} GNOME_PREFIX=${D}/usr"

	if use kde; then
		myopts="${myopts} \
			KDE_PREFIX=${D}/usr/share/applnk \
			KDE_ICON_PREFIX=${D}/usr/share/icons"
	fi

	use nls && myopts="${myopts} ENABLE_GETTEXT=1"

	make PREFIX="${D}/usr" ${myopts} install || die

	rm docs/COPYING.txt docs/INSTALL.txt
	dodoc docs/*.txt
}

pkg_postinst() {
	einfo ""
	einfo "For additional graphic stamps, you can emerge the"
	einfo "media-gfx/tuxpaint-stamps package."
	einfo ""
}

