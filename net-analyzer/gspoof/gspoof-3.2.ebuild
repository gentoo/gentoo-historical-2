# Copyright 1999-2004 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-analyzer/gspoof/gspoof-3.2.ebuild,v 1.4 2004/07/09 11:54:42 eldad Exp $

DESCRIPTION="A simple GTK/command line TCP/IP packet generator"
HOMEPAGE="http://gspoof.sourceforge.net/"
SRC_URI="http://gspoof.sourceforge.net/src/${P}.tar.gz"
LICENSE="GPL-2"
SLOT="0"
KEYWORDS="x86"

IUSE=""

DEPEND="=x11-libs/gtk+-2*
	=dev-libs/glib-2*
	>=net-libs/libnet-1.1.1"

src_compile() {
	emake || die
}

src_install() {
	exeinto /usr/bin
	doexe gspoof

	insinto /usr/share/gspoof/pixmap
	doins pixmap/icon.png

	dodoc Makefile README CHANGELOG TODO LICENSE VERSION
}
