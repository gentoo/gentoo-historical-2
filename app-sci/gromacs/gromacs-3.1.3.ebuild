# Copyright 1999-2002 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License, v2 or later
# Maintainer: George Shapovalov <george@gentoo.org>
# /space/gentoo/cvsroot/gentoo-x86/skel.ebuild,v 1.4 2002/03/12 16:05:09 tod Exp

DESCRIPTION="The ultimate Molecular Dynamics simulation package"

SRC_URI="ftp://ftp.gromacs.org/pub/gromacs/${P}.tar.gz"

HOMEPAGE="http://www.gromacs.org/"

DEPEND="mpi? ( >=lam-6.5.2 )
	>=fftw-2.1.3
	>=sys-devel/binutils-2.10.91.0.2"

RDEPEND="${DEPEND}"

src_compile() {
	./configure \
		--host=${CHOST} \
		--prefix=/usr/gromacs \
		--includedir=/usr/include/gromacs \
		--infodir=/usr/share/info \
		--enable-fortran \
		--mandir=/usr/share/man || die "./configure failed"
	emake || die
}

src_install () {
	make DESTDIR=${D} install || die

	# Install documentation.
	dodoc AUTHORS COPYING INSTALL README

	#move html docs under /usr/share/doc
	#and leave examples and templates under /usr/gromacs...
	mv ${D}/usr/gromacs/share/html ${D}/usr/share/doc/${P}
	
}
