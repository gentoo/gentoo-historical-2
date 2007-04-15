# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-plugins/gmpc-lyrics/gmpc-lyrics-0.14.0.ebuild,v 1.1 2007/04/15 14:40:58 ticho Exp $

GMPCV="0.14.0"
DESCRIPTION="This plugin fetches lyrics from the internet."
HOMEPAGE="http://sarine.nl/gmpc-plugins-lyrics-provider"
SRC_URI="http://download.sarine.nl/gmpc-${GMPCV}/plugins/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~x86"
IUSE=""

DEPEND=">=media-sound/gmpc-${GMPCV}
		dev-libs/libxml2"

src_compile ()
{
	econf || die
	emake || die
}

src_install ()
{
	make DESTDIR="${D}" install || die
}
