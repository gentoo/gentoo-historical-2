# Copyright 1999-2004 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-libs/szip/szip-1.1.ebuild,v 1.4 2004/03/15 13:23:56 dholm Exp $

MY_P="${P/-}"

DESCRIPTION="Szip is an implementation of the extended-Rice lossless compression algorithm"
HOMEPAGE="http://hdf.ncsa.uiuc.edu/HDF5/doc_resource/SZIP/"
SRC_URI="ftp://ftp.ncsa.uiuc.edu/HDF/szip/src/${MY_P}.tar.gz"
LICENSE="szip"

SLOT="0"
KEYWORDS="x86 amd64 ~ppc"

IUSE=""

DEPEND=""

S=${WORKDIR}/${MY_P}

src_compile() {
	./configure --prefix="/usr" || die
	emake CFLAGS="${CFLAGS} -DHAVE_UNISTD_H -DUSE_MMAP" || die
}

src_install() {
	dodir /usr/include
	dodir /usr/lib
	make prefix=${D}/usr install || die
}
