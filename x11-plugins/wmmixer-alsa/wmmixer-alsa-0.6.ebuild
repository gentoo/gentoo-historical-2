# Copyright 1999-2003 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/x11-plugins/wmmixer-alsa/wmmixer-alsa-0.6.ebuild,v 1.6 2003/09/29 21:55:00 mholzer Exp $

S=${WORKDIR}/${P}
DESCRIPTION="hacked version of wmmixer to make it use ALSA instead of the OSS"
SRC_URI="http://bohemians.org/~iznogood/wmmixer-alsa/${P}.tar.gz"
HOMEPAGE="http://bohemians.org/~iznogood/"

DEPEND="virtual/x11
	=media-libs/alsa-lib-0.5*"

SLOT="0"
LICENSE="GPL-2"
KEYWORDS="x86 sparc"

src_compile() {
	emake || die "emake failed"
}

src_install() {
	dodoc README COPYING
	dobin wmmixer-alsa
}
