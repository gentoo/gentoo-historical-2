# Copyright 1999-2004 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-plugins/xmms-nebulus/xmms-nebulus-0.6.0.ebuild,v 1.8 2004/07/07 00:33:26 eradicator Exp $

IUSE=""

DESCRIPTION="OpenGL/SDL visualization plugin for XMMS"
HOMEPAGE="http://nebulus.tuxfamily.org/"
SRC_URI="http://nebulus.tuxfamily.org/${P}.tar.bz2"

SLOT="0"
LICENSE="GPL-2"
#-sparc: 0.6.0: xmms segfaults after SDL thread creation
KEYWORDS="x86 amd64 -sparc"

DEPEND="media-sound/xmms
	media-libs/libsdl"

src_install () {
	make DESTDIR=${D} install || die
}

