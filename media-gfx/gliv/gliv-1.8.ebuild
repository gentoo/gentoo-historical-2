# Copyright 1999-2004 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-gfx/gliv/gliv-1.8.ebuild,v 1.3 2004/06/24 22:39:20 agriffis Exp $

DESCRIPTION="An image viewer that uses OpenGL"
HOMEPAGE="http://guichaz.free.fr/gliv/"
SRC_URI="http://guichaz.free.fr/gliv/gliv-${PV}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="x86"
IUSE="nls"

DEPEND=">=x11-libs/gtk+-2.2
	>=x11-libs/gtkglext-1.0.2
	nls? ( sys-devel/gettext )"

src_compile() {
	econf \
		--disable-dependency-tracking \
		`use_enable nls` || die
	emake || die "emake failed"
}

src_install() {
	einstall || die
	dodoc README NEWS THANKS
}
