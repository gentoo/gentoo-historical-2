# Copyright 1999-2004 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-irc/lostirc/lostirc-0.3.3.ebuild,v 1.5 2004/06/17 20:28:03 swegener Exp $

inherit base

IUSE="kde gnome"
DESCRIPTION="A simple but functional graphical IRC client"
HOMEPAGE="http://lostirc.sourceforge.net/"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.gz"
RESTRICT="nomirror"
SLOT="0"
LICENSE="GPL-2"
KEYWORDS="~x86 ~ppc ~amd64 ~sparc"
DEPEND=">=sys-apps/sed-4*
	=dev-cpp/gtkmm-2.2.11
	>=dev-libs/libsigc++-1.2"

src_compile() {
	# patch po/Makefile.in.in
	sed -i -r 's:(^mkinstalldirs = ).*:\1$(MKINSTALLDIRS):' po/Makefile.in.in || die
	local myconf=""
	myconf="${myconf} `use_with gnome`"
	myconf="${myconf} `use_with kde`"
	econf ${myconf} || die
	base_src_compile make
}

src_install() {
	base_src_install
	dodoc AUTHORS ChangeLog COPYING INSTALL README TODO NEWS
}
