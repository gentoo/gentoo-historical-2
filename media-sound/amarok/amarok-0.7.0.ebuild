# Copyright 1999-2004 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-sound/amarok/amarok-0.7.0.ebuild,v 1.4 2004/04/16 01:17:49 caleb Exp $

inherit kde
need-kde 3

DESCRIPTION="amaroK is a media player for KDE"
HOMEPAGE="http://amarok.sourceforge.net/"
SRC_URI="mirror://sourceforge/amarok/${P}.tar.bz2"
LICENSE="GPL-2"
SLOT="0"
KEYWORDS="x86"

DEPEND="kde-base/kdemultimedia"

src_compile() {
	PREFIX=`kde-config --prefix`
	kde_src_compile myconf configure || die
	make || die
}
