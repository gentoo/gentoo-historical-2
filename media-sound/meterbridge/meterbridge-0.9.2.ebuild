# Copyright 1999-2004 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-sound/meterbridge/meterbridge-0.9.2.ebuild,v 1.4 2004/04/18 16:29:03 aliz Exp $

DESCRIPTION="Software meterbridge for the UNIX based JACK audio system."
HOMEPAGE="http://plugin.org.uk/meterbridge/"
SRC_URI="http://plugin.org.uk/meterbridge/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="x86 ~amd64"

IUSE=""

DEPEND="virtual/jack \
	media-libs/sdl-image"

src_compile() {
	econf || die
	emake || die
}

src_install() {
	make DESTDIR=${D} install || die
	#einstall || die
}
