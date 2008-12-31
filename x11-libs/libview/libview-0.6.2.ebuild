# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/x11-libs/libview/libview-0.6.2.ebuild,v 1.1 2008/12/31 02:11:32 ikelos Exp $

inherit gnome2 eutils

DESCRIPTION="VMware's Incredibly Exciting Widgets"
HOMEPAGE="http://view.sourceforge.net"
SRC_URI="mirror://sourceforge/view/${P}.tar.bz2"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND=">=x11-libs/gtk+-2.4.0
		 >=dev-cpp/gtkmm-2.4"
DEPEND="${RDEPEND}
	dev-util/pkgconfig"

src_unpack() {
	gnome2_src_unpack

	# Fix the pkgconfig file
	epatch "${FILESDIR}"/${PN}-0.5.6-pcfix.patch
}

src_compile() {
	CPPFLAGS="${CPPFLAGS} -U GTK_DISABLE_DEPRECATED"
	econf || die "Configure failed."
	emake || die "Compilation failed."
}
