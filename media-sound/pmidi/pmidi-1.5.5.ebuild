# Copyright 1999-2004 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-sound/pmidi/pmidi-1.5.5.ebuild,v 1.7 2004/04/18 15:39:21 aliz Exp $

DESCRIPTION="Command line midi player for ALSA."
HOMEPAGE="http://www.parabola.demon.co.uk/alsa/pmidi.html"

SRC_URI="mirror://sourceforge/pmidi/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"

DEPEND=">=media-libs/alsa-lib-0.9.0_rc6"
KEYWORDS="x86 ~amd64"

S=${WORKDIR}/${P}

src_compile() {
	econf || die "./configure failed"
	make clean
	emake || die "Make Failed"
}

src_install() {
	einstall || die "Installation Failed"
	dodoc AUTHORS COPYING ChangeLog NEWS README
}
