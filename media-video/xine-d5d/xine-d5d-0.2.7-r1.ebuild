# Copyright 1999-2002 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-video/xine-d5d/xine-d5d-0.2.7-r1.ebuild,v 1.3 2002/12/01 23:24:23 mholzer Exp $

S=${WORKDIR}/${P}
DESCRIPTION="Captain CSS menu plugin for the xine media player"
HOMEPAGE="http://www.captaincss.tk/"
SRC_URI="http://debianlinux.net/${P}.tgz"

DEPEND=">=media-libs/xine-lib-0.9.12"

SLOT="0"
LICENSE="LGPL-2.1"
KEYWORDS="x86 ppc"

src_unpack() {

	unpack ${A}

	cd ${WORKDIR}
	patch -p0 < ${FILESDIR}/${PF}-gentoo.diff || die "Patching failed"

}

src_compile() {

	econf

	if use ppc || use sparc || use sparc64
	then
		einfo "Configuring for Big-Endian Architecture"
		echo "#define WORDS_BIGENDIAN" >> config.h
	fi
	
	emake || die
}

src_install () {

	make DESTDIR=${D} install || die
	dodoc AUTHORS COPYING ChangeLog INSTALL README NEWS
}
