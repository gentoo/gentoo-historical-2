# Copyright 1999-2002 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/x11-libs/xosd/xosd-2.0.1-r1.ebuild,v 1.1 2003/01/08 09:32:05 aliz Exp $

S=${WORKDIR}/${P}
DESCRIPTION="Library for overlaying text/glyphs in X-Windows \
X-On-Screen-Display plus binary for sending text from command line."
HOMEPAGE="http://www.ignavus.net/"
SRC_URI="http://www.ignavus.net/${P}.tar.gz"

IUSE="xmms"
DEPEND="virtual/x11
	xmms? ( media-sound/xmms
		media-libs/gdk-pixbuf )"
RDEPEND=${DEPEND}
SLOT="1"
LICENSE="GPL-2"
KEYWORDS="x86 ~sparc"

src_unpack() {
	unpack ${A}
	cd ${S}

	patch -p0 < ${FILESDIR}/configure-gentoo.diff || die
}

src_compile() {
	local myconf

	if [ "`use xmms`" ]; then
		myconf="--with-plugindir=/usr/lib/xmms"
	else
		myconf="--without-plugindir"
	fi

	econf || die
	emake || die
}

src_install() {
	make DESTDIR=${D} install || die
	dodoc AUTHORS ChangeLog NEWS COPYING README
}
