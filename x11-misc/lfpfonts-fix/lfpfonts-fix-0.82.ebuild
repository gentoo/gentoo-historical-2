# Copyright 1999-2003 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/x11-misc/lfpfonts-fix/lfpfonts-fix-0.82.ebuild,v 1.10 2003/02/13 17:16:26 vapier Exp $

S=${WORKDIR}/${PN}
DESCRIPTION="Linux Font Project fixed-width fonts"
SRC_URI="http://dreamer.nitro.dk/linux/lfp/${P}.tar.bz2"
HOMEPAGE="http://dreamer.nitro.dk/linux/lfp/"
LICENSE="Public Domain"
KEYWORDS="x86 sparc  ppc"
SLOT="0"

DEPEND="virtual/x11"

src_install() {
	dodoc doc/*
	cd lfp-fix
	insinto /usr/X11R6/lib/X11/fonts/lfp-fix
	insopts -m0644
	doins *
}
