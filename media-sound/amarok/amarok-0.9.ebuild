# Copyright 1999-2004 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-sound/amarok/amarok-0.9.ebuild,v 1.7 2004/06/24 23:50:00 agriffis Exp $

inherit kde

DESCRIPTION="amaroK is a media player for KDE"
HOMEPAGE="http://amarok.sourceforge.net/"
SRC_URI="mirror://sourceforge/amarok/${P}.tar.bz2"
LICENSE="GPL-2"
SLOT="0"
KEYWORDS="x86 ~ppc ~amd64"
IUSE="gstreamer"

DEPEND=">=kde-base/kdemultimedia-3.2
	gstreamer? (
		media-libs/gstreamer
		media-libs/gst-plugins
	)"

need-kde 3

src_compile() {
	PREFIX=`kde-config --prefix`
	kde_src_compile myconf configure || die
	make || die
}
