# Copyright 1999-2004 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-video/konverter/konverter-0.6.ebuild,v 1.2 2004/04/11 23:35:48 kugelfang Exp $

inherit kde
need-kde 3

DESCRIPTION="A KDE MEncoder frontend for video-conversion."
HOMEPAGE="http://www.libsdl.de/projects/konverter/"
SRC_URI="http://p15108941.pureserver.info/libsdl/projects/${PN}/sources/${P}.tar.gz"
LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~x86 ~ppc ~amd64"
IUSE=""


DEPEND="media-video/mplayer"

src_install() {
	einstall || die
	dodoc ChangeLog TODO README NEWS INSTALL COPYING AUTHORS || die
}

