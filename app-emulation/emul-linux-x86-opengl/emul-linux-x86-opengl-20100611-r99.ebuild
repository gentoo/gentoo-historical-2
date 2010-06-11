# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-emulation/emul-linux-x86-opengl/emul-linux-x86-opengl-20100611-r99.ebuild,v 1.1 2010/06/11 14:44:35 pacho Exp $

inherit emul-linux-x86

LICENSE="LGPL-2 MIT"

SRC_URI="mirror://gentoo/${PN}-${PV}-r99.tar.bz2"

KEYWORDS="-* ~amd64 ~amd64-linux"
IUSE=""

DEPEND="app-admin/eselect-opengl"
RDEPEND=">=app-emulation/emul-linux-x86-xlibs-20100611
	!<app-emulation/emul-linux-x86-xlibs-20100611
	media-libs/mesa"

src_unpack() {
	emul-linux-x86_src_unpack
	rm -f "${S}/usr/lib32/libGL.so" || die
}

pkg_postinst() {
	#update GL symlinks
	eselect opengl set --use-old
}
