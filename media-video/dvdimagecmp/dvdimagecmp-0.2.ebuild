# Copyright 1999-2004 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-video/dvdimagecmp/dvdimagecmp-0.2.ebuild,v 1.2 2004/10/15 16:06:07 dholm Exp $

DESCRIPTION="Tool to compare a burned DVD with an image to check for errors"
HOMEPAGE="http://home.zonnet.nl/panteltje/dvd/"
SRC_URI="http://home.zonnet.nl/panteltje/dvd/${P}.tgz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="x86 ~ppc"
IUSE=""

DEPEND=""

src_compile() {
	emake CFLAGS="$CFLAGS" || die "make failed"
}

src_install() {
	dobin dvdimagecmp
	dodoc CHANGES LICENSE README *.lsm
}
