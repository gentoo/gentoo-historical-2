# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/x11-libs/libfm/libfm-0.1.5.ebuild,v 1.2 2010/03/13 16:30:05 yngwin Exp $

EAPI="2"
inherit eutils

DESCRIPTION="Library for file management"
HOMEPAGE="http://pcmanfm.sourceforge.net/"
SRC_URI="mirror://sourceforge/pcmanfm/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64"
IUSE="debug demo"

RDEPEND="dev-libs/glib:2
	x11-libs/gtk+:2
	>=lxde-base/menu-cache-0.3.2"
DEPEND="${RDEPEND}
	>=dev-util/intltool-0.40
	dev-util/pkgconfig
	sys-devel/gettext"

src_configure() {
	strip-linguas -i "${S}/po"
	econf --sysconfdir=/etc $(use_enable debug) $(use_enable demo)
}

src_install() {
	emake DESTDIR="${D}" install || die
	dodoc AUTHORS TODO || die
}
