# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-p2p/xmule/xmule-1.10.0.ebuild,v 1.1 2005/03/22 21:58:33 sekretarz Exp $

inherit wxwidgets eutils

DESCRIPTION="wxWidgets based client for the eDonkey/eMule/lMule network"
HOMEPAGE="http://xmule.ws/"
SRC_URI="http://download.berlios.de/${PN}/${P}.tar.bz2"

LICENSE="LGPL-2 ZLIB GPL-2"
SLOT="0"
KEYWORDS="~x86 ~amd64 ~ppc"

IUSE="nls gtk2 debug"

DEPEND=">=x11-libs/wxGTK-2.4*
	nls? ( sys-devel/gettext )
	>=sys-libs/zlib-1.2.1
	!net-p2p/amule
	>=dev-libs/crypto++-5.2.1"

src_unpack() {
	unpack ${A}
	cd ${S}
	sed -i 's/@datadir@/${DESTDIR}@datadir@/' Makefile.in || die
}

src_compile () {
	local myconf=

	if ! use gtk2 ; then
		need-wxwidgets gtk
	else
		need-wxwidgets gtk2
	fi

	myconf="${myconf} --with-zlib=/tmp/zlib/"

	myconf="${myconf} `use_enable debug` `use_enable nls`"

	econf ${myconf} || die
	emake || die
}

src_install () {
	einstall mkinstalldirs=${S}/mkinstalldirs DESTDIR=${D} || die
	rm -rf ${D}/var || die
}
