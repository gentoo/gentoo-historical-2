# Copyright 1999-2003 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/x11-libs/xosd/xosd-2.2.5.ebuild,v 1.2 2003/09/30 03:02:43 vapier Exp $

DESCRIPTION="Library for overlaying text/glyphs in X-Windows X-On-Screen-Display plus binary for sending text from command line"
HOMEPAGE="http://www.ignavus.net/"
SRC_URI="http://www.ignavus.net/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~x86 ~sparc ~ppc ~alpha ~hppa ~mips ~arm"
IUSE="xmms"

DEPEND="virtual/x11
	xmms? ( media-sound/xmms
	>=media-libs/gdk-pixbuf-0.22.0 )"

src_unpack() {
	unpack ${A}
	cd ${S}
	epatch ${FILESDIR}/${PV}-xmms-trackpos.patch
}

src_compile() {
	local myconf=""
	[ `use xmms` ] \
		&& myconf="--with-plugindir=/usr/lib/xmms/General" \
		|| myconf="--without-plugindir"

	econf ${myconf} || die
	emake || die
}

src_install() {
	make DESTDIR=${D} install || die
	dodoc AUTHORS ChangeLog NEWS COPYING README
}
