# Copyright 1999-2004 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-libs/libshout/libshout-1.0.9.ebuild,v 1.7 2004/04/16 23:34:23 dholm Exp $

S=${WORKDIR}/${P}
DESCRIPTION="libshout is a library for connecting and sending data to icecast servers."
SRC_URI="http://developer.icecast.org/libshout/releases/${P}.tar.gz"
HOMEPAGE="http://developer.icecast.org/libshout/"

SLOT="0"
KEYWORDS="x86 sparc ~ppc"
LICENSE="GPL-2"

DEPEND="sys-devel/gcc
	virtual/glibc"

src_compile() {
	./configure --prefix=/usr \
		--mandir=/usr/share/man || die

	emake || die
}

src_install () {
	make DESTDIR=${D} install || die
}


