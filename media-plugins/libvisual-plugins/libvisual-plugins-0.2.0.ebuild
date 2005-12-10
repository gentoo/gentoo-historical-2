# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-plugins/libvisual-plugins/libvisual-plugins-0.2.0.ebuild,v 1.5 2005/12/10 16:50:57 flameeyes Exp $

inherit eutils

DESCRIPTION="Visualization plugins for use with the libvisual framework."
HOMEPAGE="http://libvisual.sourceforge.net/"
SRC_URI="mirror://sourceforge/libvisual/${P}.tar.gz"
LICENSE="GPL-2"

SLOT="0"
KEYWORDS="amd64 ppc ~sparc x86"
IUSE="debug esd gtk jack opengl"

RDEPEND=">=media-libs/libvisual-0.2.0
	opengl? ( || ( media-libs/mesa virtual/opengl ) )
	esd? ( media-sound/esound )
	jack? ( >=media-sound/jack-audio-connection-kit-0.98 )
	gtk? ( >=x11-libs/gtk+-2 )
	|| ( (
			media-libs/fontconfig
			x11-libs/libX11
			x11-libs/libXext
			x11-libs/libXrender
		) virtual/x11 )"

DEPEND="${RDEPEND}
	|| ( (
			x11-base/xorg-server
			x11-libs/libXt
		) virtual/x11 )
	>=dev-util/pkgconfig-0.14"

src_compile() {
	# stupid configure assumes $x_libaries cannot be empty
	epatch "${FILESDIR}/${P}-configure.patch"
	epatch "${FILESDIR}/${P}-mkdirhier.patch"

	econf $(use_enable debug) || die
	emake || die
}

src_install() {
	make DESTDIR="${D}" install || die
	dodoc AUTHORS ChangeLog NEWS README TODO
}
