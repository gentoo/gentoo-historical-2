# Copyright 1999-2002 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/x11-libs/guile-gtk/guile-gtk-0.19.ebuild,v 1.2 2002/11/23 07:13:54 vapier Exp $

DESCRIPTION="GTK+ bindings for guile"
SRC_URI="http://www.ping.de/sites/zagadka/guile-gtk/download/guile-gtk-0.19.tar.gz"
HOMEPAGE="http://www.ping.de/sites/zagadka/guile-gtk/"

KEYWORDS="~x86"
LICENSE="GPL-2"
SLOT="0"

DEPEND="=dev-util/guile-1.4*
	=x11-libs/gtk+-1.2*"

src_compile() {
	econf
	emake || die
}

src_install() {
	einstall

	dodoc INSTALL README* COPYING AUTHORS Changelog NEWS TODO
	insinto ${D}/usr/share/guile-gtk/examples
	doins ${S}/examples/*.scm ${S}/examples/*.xpm
}
