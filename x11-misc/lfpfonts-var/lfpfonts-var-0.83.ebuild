# Copyright 1999-2002 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/x11-misc/lfpfonts-var/lfpfonts-var-0.83.ebuild,v 1.9 2002/12/09 04:41:53 manson Exp $

S=${WORKDIR}/${PN}
DESCRIPTION="Linux Font Project variable-width fonts"
SRC_URI="http://dreamer.nitro.dk/linux/lfp/${P}.tar.bz2"
HOMEPAGE="http://dreamer.nitro.dk/linux/lfp/"
LICENSE="Public Domain"
SLOT="0"
KEYWORDS="x86 sparc  ppc"

DEPEND="virtual/x11"

src_install() {
	dodoc doc/*
	cd lfp-var
	insinto /usr/X11R6/lib/X11/fonts/lfp-var
	insopts -m0644
	doins *
}
