# Copyright 1999-2004 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-plugins/xmms-iris/xmms-iris-0.11.ebuild,v 1.8 2004/06/24 23:41:08 agriffis Exp $

IUSE=""

MY_P=${P/xmms-/}
S=${WORKDIR}/${MY_P}
DESCRIPTION="XMMS OpenGL visualization plugin"
SRC_URI="http://cdelfosse.free.fr/xmms-iris/${MY_P}.tar.gz"
HOMEPAGE="http://cdelfosse.free.fr/xmms-iris/"

SLOT="0"
LICENSE="GPL-2"
KEYWORDS="x86 ~ppc amd64"

DEPEND="virtual/opengl
	=x11-libs/gtk+-1.2*
	>=media-sound/xmms-1.2.6"

src_install () {
	dodir /usr/lib/xmms/Visualization

	make DESTDIR=${D} install || die

	dodoc AUTHORS COPYING ChangeLog INSTALL README TODO NEWS
}
