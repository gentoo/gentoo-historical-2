# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sci-misc/gri/gri-2.12.7.ebuild,v 1.6 2006/11/23 06:54:35 opfer Exp $

inherit eutils

IUSE=""

DESCRIPTION="language for scientific graphics programming"
HOMEPAGE="http://gri.sourceforge.net/"
SRC_URI="mirror://sourceforge/gri/${P}.tgz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="x86 amd64 ~ppc"

# app-text/ghostscript-esp is needed, as it is the only version that gri
# builds with, see bug #155236
DEPEND=">=sci-libs/netcdf-3.5.0
	virtual/tetex
	media-gfx/imagemagick
	app-text/ghostscript-esp"

src_compile() {
	econf || die
	emake || die
}

src_install() {
	# Replace PREFIX now and correct paths in the startup message.
	sed -e s,PREFIX/share/doc/gri/,/usr/share/doc/${P}/, -i ${S}/startup.msg

	einstall || die

	dodoc AUTHOR README
	#move docs to the proper place
	mv ${D}/usr/share/gri/doc/* ${D}/usr/share/doc/${PF}
	rmdir ${D}/usr/share/gri/doc/
}
