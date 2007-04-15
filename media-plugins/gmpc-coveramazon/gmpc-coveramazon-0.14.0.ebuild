# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-plugins/gmpc-coveramazon/gmpc-coveramazon-0.14.0.ebuild,v 1.1 2007/04/15 14:08:16 ticho Exp $

GMPCV="0.14.0"
DESCRIPTION="This plugin fetches cover art, and album information from amazon."
HOMEPAGE="http://sarine.nl/amazon-provider"
SRC_URI="http://download.sarine.nl/gmpc-${GMPCV}/plugins/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~x86"
IUSE=""

RDEPEND=">=media-sound/gmpc-${GMPCV}"

src_compile ()
{
	econf || die
	emake || die
}

src_install ()
{
	make DESTDIR="${D}" install || die
}
