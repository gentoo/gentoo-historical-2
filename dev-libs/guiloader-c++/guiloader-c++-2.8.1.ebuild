# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-libs/guiloader-c++/guiloader-c++-2.8.1.ebuild,v 1.2 2007/02/27 12:50:54 pva Exp $

DESCRIPTION="C++ binding to GuiLoader library"
HOMEPAGE="http://crow-designer.sourceforge.net"
SRC_URI="mirror://sourceforge/crow-designer/${P}.tar.bz2"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="~x86 ~amd64"
IUSE=""

DEPEND=">=x11-libs/gtk+-2.8.0
		>=dev-cpp/gtkmm-2.8.0
		>=dev-libs/guiloader-2.8.0"

src_compile() {
	econf || die "configuration failed"
	emake || die "compilation failed"
}

src_install() {
	emake DESTDIR="${D}" install || die "make install failed"
	dodoc AUTHORS README NEWS
}
