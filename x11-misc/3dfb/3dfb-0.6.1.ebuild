# Copyright 1999-2004 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/x11-misc/3dfb/3dfb-0.6.1.ebuild,v 1.4 2004/09/07 23:12:51 swegener Exp $

DESCRIPTION="3D File Browser"
HOMEPAGE="http://sourceforge.net/projects/dz3d/"
SRC_URI="mirror://sourceforge/dz3d/${P}.tar.gz"
RESTRICT="nomirror"
LICENSE="GPL-2"
SLOT="0"
KEYWORDS="x86 ppc"
IUSE=""

RDEPEND=">=dev-libs/glib-2
	virtual/glut
	virtual/opengl"
DEPEND="${DEPEND}
	dev-util/pkgconfig"

src_install() {
	make DESTDIR=${D} install || die "install failed"

	dodoc AUTHORS ChangeLog NEWS README WISHLIST
}
