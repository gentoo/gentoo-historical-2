# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/x11-libs/xosd/xosd-2.2.10.ebuild,v 1.2 2005/02/25 16:56:46 agriffis Exp $

inherit eutils

IUSE="xinerama xmms"

DESCRIPTION="Library for overlaying text/glyphs in X-Windows X-On-Screen-Display plus binary for sending text from command line"
HOMEPAGE="http://www.ignavus.net/"
SRC_URI="http://www.ignavus.net/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~x86 ~sparc ppc ~alpha ~hppa ia64 ~amd64"

DEPEND="virtual/x11
	xmms? ( media-sound/xmms >=media-libs/gdk-pixbuf-0.22.0 )"

src_unpack() {
	unpack ${A}
	cd ${S}
	epatch ${FILESDIR}/2.2.8-xmms-trackpos.patch
}

src_compile() {
	local myconf=""

	use xinerama || myconf="${myconf} --disable-xinerama"

	use xmms || myconf="${myconf} --disable-new-plugin"

	econf ${myconf} || die

	emake || die
}

src_install() {
	make DESTDIR=${D} install || die
	dodoc AUTHORS ChangeLog NEWS COPYING README

	if [ -d ${D}no ]; then
		rmdir ${D}no
	fi
}
