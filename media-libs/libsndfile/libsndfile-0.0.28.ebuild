# Copyright 1999-2004 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-libs/libsndfile/libsndfile-0.0.28.ebuild,v 1.8 2004/06/24 23:14:31 agriffis Exp $

S=${WORKDIR}/${P}
DESCRIPTION="A C library for reading and writing files containing sampled sound"
HOMEPAGE="http://www.zipworld.com.au/~erikd/libsndfile/"
SRC_URI="http://www.zipworld.com.au/~erikd/libsndfile/${P}.tar.gz"

SLOT="0"
LICENSE="LGPL-2.1"
KEYWORDS="x86 ~ppc sparc "

DEPEND="virtual/glibc"

src_install () {

	make DESTDIR=${D} install || die
	dodoc AUTHORS COPYING ChangeLog INSTALL NEWS README TODO

}
