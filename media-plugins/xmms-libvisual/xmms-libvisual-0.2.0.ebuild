# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-plugins/xmms-libvisual/xmms-libvisual-0.2.0.ebuild,v 1.1 2005/03/02 16:42:22 greg_g Exp $

inherit eutils

MY_PN="libvisual-xmms"
MY_P="${MY_PN}-${PV}"
S="${WORKDIR}/${MY_P}"

DESCRIPTION="an abstraction library for applications to create audio visualisation plugins"
HOMEPAGE="http://libvisual.sourceforge.net/"
SRC_URI="mirror://sourceforge/libvisual/${MY_P}.tar.gz"
LICENSE="GPL-2"

SLOT="0"
KEYWORDS="~amd64 ~ppc ~sparc ~x86"
IUSE=""

RDEPEND="media-sound/xmms
	 >=media-libs/libvisual-0.2
	 virtual/opengl
	 media-libs/libsdl"

DEPEND="${DEPEND}
	>=dev-util/pkgconfig-0.14"

src_install() {
	make DESTDIR="${D}" install || die

	if [ "$(get_libdir)" != "lib" ]; then
		mv ${D}/usr/lib ${D}/usr/$(get_libdir)
	fi

	dodoc AUTHORS ChangeLog NEWS README TODO
}
