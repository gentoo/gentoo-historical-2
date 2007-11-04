# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/www-client/downman/downman-0.0.5-r1.ebuild,v 1.3 2007/11/04 14:02:32 drac Exp $

WANT_AUTOMAKE=1.7

inherit autotools eutils gnome2

DESCRIPTION="Suite of programs to download files."
HOMEPAGE="http://downman.sourceforge.net"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~x86 ppc ~sparc alpha amd64"
IUSE=""

RDEPEND=">=x11-libs/gtk+-2
	>=gnome-base/libgnome-2
	>=gnome-base/libgnomeui-2
	>=gnome-base/libglade-2
	>=dev-libs/libxml2-2"
DEPEND="${RDEPEND}
	dev-util/pkgconfig"

DOCS="AUTHORS ChangeLog NEWS README"

src_unpack() {
	unpack ${A}
	cd "${S}"
	epatch "${FILESDIR}"/${P}-gcc-4.patch
	epatch "${FILESDIR}"/${P}-strlen.patch
	epatch "${FILESDIR}"/${P}-asneeded.patch
	eautoreconf
}
