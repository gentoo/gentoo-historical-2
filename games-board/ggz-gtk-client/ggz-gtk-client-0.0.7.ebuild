# Copyright 1999-2003 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/games-board/ggz-gtk-client/ggz-gtk-client-0.0.7.ebuild,v 1.2 2003/11/28 00:02:14 mr_bones_ Exp $

DESCRIPTION="The gtk client for GGZ Gaming Zone"
HOMEPAGE="http://ggz.sourceforge.net/"
SRC_URI="mirror://sourceforge/ggz/${P}.tar.gz"

KEYWORDS="~x86 ~ppc"
LICENSE="GPL-2"
SLOT="0"
IUSE="gtk2"

DEPEND="=dev-games/ggz-client-libs-0.0.7
	>=sys-apps/sed-4
	gtk2? ( =x11-libs/gtk+-2* )
	!gtk2? ( =x11-libs/gtk+-1* )"

src_compile() {
	local myconf="--enable-gtk=gtk2"
	use gtk2 || myconf="--enable-gtk"

	econf ${myconf} --disable-debug || die
	sed -i '/^SUBDIRS/s:po::' Makefile
	emake || die
}

src_install() {
	make DESTDIR=${D} install || die
	dodoc AUTHORS ChangeLog INSTALL NEWS QuickStart.GGZ README* TODO
}
