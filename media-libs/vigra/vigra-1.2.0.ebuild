# Copyright 1999-2004 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-libs/vigra/vigra-1.2.0.ebuild,v 1.3 2004/12/29 02:42:04 ribosome Exp $
DESCRIPTION="Vision with Generic Algorithms"

HOMEPAGE="http://kogs-www.informatik.uni-hamburg.de/~koethe/vigra"

SRC_URI="http://kogs-www.informatik.uni-hamburg.de/~koethe/vigra/${P/-}.tar.gz"

LICENSE="VIGRA"

SLOT="0"

KEYWORDS="~x86 ~ppc"

IUSE=""

DEPEND="sys-devel/gcc
		media-libs/libpng
		media-libs/tiff
		media-libs/jpeg
		sys-libs/zlib
		sci-libs/fftw"

S=${WORKDIR}/${P/-}

src_compile() {

	./configure \
		--host=${CHOST} \
		--prefix=/usr || die "./configure failed"
	emake || die
}

src_install() {
	make DESTDIR=${D} prefix=${D}/usr install || die
}
