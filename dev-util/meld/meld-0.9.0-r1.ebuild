# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-util/meld/meld-0.9.0-r1.ebuild,v 1.5 2005/01/27 21:34:02 agriffis Exp $

inherit python eutils

DESCRIPTION="A graphical (GNOME 2) diff and merge tool"
HOMEPAGE="http://meld.sourceforge.net/"
SRC_URI="mirror://sourceforge/meld/${P}.tgz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="x86 ~alpha"
IUSE=""

DEPEND=">=dev-lang/python-2.2
	>=gnome-base/libglade-2
	>=gnome-base/libgnome-2
	>=dev-python/gnome-python-1.99.15
	>=dev-python/pygtk-1.99.15
	>=dev-python/pyorbit-1.99.0"

src_unpack(){
	unpack ${A}
	EPATCH_OPTS="-d ${S}" epatch ${FILESDIR}/${PN}-0.9.0-gentoo.diff
	EPATCH_OPTS="-d ${S}" epatch ${FILESDIR}/${PN}-0.9.0-gtktoolbar.patch
}

src_install() {
	insinto /usr/lib/meld
	doins *.py
	dobin meld
	insinto /usr/share/meld/glade2
	doins glade2/*
	insinto /usr/share/meld/glade2/pixmaps
	doins glade2/pixmaps/*
	insinto /usr/share/applications
	doins meld.desktop
	dodoc AUTHORS COPYING INSTALL TODO.txt
	dohtml manual/*
}

pkg_postinst() {
	python_mod_optimize /usr/lib/meld
}

pkg_postrm() {
	python_mod_cleanup /usr/lib/meld
}
