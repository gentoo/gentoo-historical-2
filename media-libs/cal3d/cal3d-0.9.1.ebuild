# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-libs/cal3d/cal3d-0.9.1.ebuild,v 1.8 2005/05/01 17:02:05 hansmi Exp $

DESCRIPTION="Cal3D is a skeletal based character animation library"
HOMEPAGE="http://cal3d.sourceforge.net/"
SRC_URI="mirror://sourceforge/cal3d/${P}.tar.bz2"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="x86 ppc"
IUSE=""

RDEPEND="virtual/libc"

DEPEND=">=sys-devel/automake-1.4
	>=sys-devel/autoconf-2.13"

src_compile() {
	./autogen.sh
	econf || die
	emake || die
}

src_install() {
	einstall || die
}
