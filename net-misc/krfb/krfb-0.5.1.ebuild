# Copyright 1999-2002 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# Author Bart Verwilst <verwilst@gentoo.org>
# $Header: /var/cvsroot/gentoo-x86/net-misc/krfb/krfb-0.5.1.ebuild,v 1.4 2002/07/08 18:14:53 phoenix Exp $ 

inherit kde-base || die

need-kde 2.2
DESCRIPTION="KDE Desktop Sharing Application"
SRC_URI="http://www.tjansen.de/krfb/${PN}-0.5.tar.gz"
HOMEPAGE="http://www.tjansen.de/krfb/"
KEYWORDS="x86"
LICENSE="GPL-2"

src_install() {

	mkdir -p ${D}/${KDE2DIR}/share/apps/krfb
	make DESTDIR=${D} install || die

}


