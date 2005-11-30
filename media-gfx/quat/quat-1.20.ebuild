# Copyright 1999-2003 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-gfx/quat/quat-1.20.ebuild,v 1.1 2003/09/12 04:16:31 vapier Exp $

DESCRIPTION="A 3D quaternionic fractal generator"
HOMEPAGE="http://www.physcip.uni-stuttgart.de/phy11733/quat_e.html"
SRC_URI="http://www.physcip.uni-stuttgart.de/phy11733/download/quat-1.20.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="x86"

DEPEND="X? ( >=x11-libs/fltk-1.1 virtual/x11 )
	>=sys-libs/zlib-1.1.4"
RDEPEND=""

src_compile() {
	export FLUID=`which fluid` # needed because configure trys an invalid option
	econf \
		`use_enable X gui` \
		`use_enable debug` \
		`use_enable debug prof` \
		|| die "configure failure" 
	emake || die "make failure"
}

src_install() {
	make DESTDIR=${D} install || die "make install failure"
	dodoc AUTHORS ChangeLog NEWS README
}
