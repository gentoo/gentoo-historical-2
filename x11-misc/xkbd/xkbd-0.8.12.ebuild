# Copyright 1999-2004 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/x11-misc/xkbd/xkbd-0.8.12.ebuild,v 1.3 2004/04/11 17:36:57 pyrania Exp $

DESCRIPTION="Xkbd - onscreen soft keyboard for X11"
HOMEPAGE="http://handhelds.org/~mallum/xkbd/"
SRC_URI="http://handhelds.org/~mallum/xkbd/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"

KEYWORDS="x86"

IUSE="doc debug"

DEPEND="sys-devel/libtool
	virtual/x11
	media-libs/freetype
	virtual/xft
	dev-libs/expat
	sys-libs/zlib
	doc? ( app-text/docbook-sgml-utils )"

src_compile() {
	econf\
	`use_enable debug`

	emake || die

	if [ `use doc` ]; then
		docbook2html README
	fi
}

src_install() {
	einstall || die
	dodoc AUTHORS COPYING NEWS README

	if [ `use doc` ]; then
		insinto /usr/share/doc/${PF}/html
		doins *.html
	fi
}
