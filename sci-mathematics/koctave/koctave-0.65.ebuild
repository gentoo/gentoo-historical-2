# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sci-mathematics/koctave/koctave-0.65.ebuild,v 1.5 2005/04/24 14:57:10 weeve Exp $

inherit kde

DESCRIPTION="A KDE GUI for Octave numerical computing system"
HOMEPAGE="http://bubben.homelinux.net/~matti/koctave/"
SRC_URI="http://bubben.homelinux.net/~matti/koctave/${PN}3-0.65.tar.bz2"
S=${WORKDIR}/${PN}3-${PV}

SLOT="0"
LICENSE="GPL-2"
KEYWORDS="x86 ~amd64 ~ppc ~sparc"
IUSE=""

DEPEND="virtual/libc
	sci-mathematics/octave
	|| ( kde-base/kdebase-meta kde-base/kdebase )"

need-kde 3

src_unpack() {
	kde_src_unpack
	use arts || epatch ${FILESDIR}/${P}-arts-configure.patch
}
