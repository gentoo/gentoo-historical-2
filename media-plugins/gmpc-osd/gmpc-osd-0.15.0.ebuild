# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-plugins/gmpc-osd/gmpc-osd-0.15.0.ebuild,v 1.4 2007/07/25 12:19:18 gustavoz Exp $

DESCRIPTION="This plugin provides an on-screen-display by xosd."
HOMEPAGE="http://sarine.nl/xosd-on-screen-display"
SRC_URI="http://download.sarine.nl/gmpc-${PV}/plugins/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~sparc ~x86"
IUSE=""

DEPEND=">=media-sound/gmpc-${PV}
		dev-libs/libxml2
		x11-libs/xosd"

src_compile ()
{
	econf || die
	emake || die
}

src_install ()
{
	make DESTDIR="${D}" install || die
}
