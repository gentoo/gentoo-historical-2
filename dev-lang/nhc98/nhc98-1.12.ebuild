# Copyright 1999-2002 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# /space/gentoo/cvsroot/gentoo-x86/dev-lang/nhc98/nhc98-1.12.ebuild,v 1.1 2002/06/09 07:38:07 george Exp

IUSE="readline"

TARBALL=nhc98src-${PV}.tar.gz

DESCRIPTION="Haskell 98 compiler"
SRC_URI="ftp://ftp.cs.york.ac.uk/pub/haskell/nhc98/${TARBALL}"
HOMEPAGE="http://www.cs.york.ac.uk/fp/nhc98/"

SLOT="0"
LICENSE="nhc98"
KEYWORDS="x86 sparc sparc64"

DEPEND="readline? ( >=readline-4.1 )"

src_unpack() {
	# unpack the source
	unpack "${TARBALL}"
	# patch to fix the getenv bug when tracing
	cd ${P}
	patch -p0 < ${FILESDIR}/nhc98-1.12-getenv.patch
}

src_compile() {

	./configure --buildwith=gcc \
		--prefix=/usr --installdir=/usr \
		-man -docs \
		--buildopts="${CFLAGS} --host=${CHOST}" || die "./configure failed"
	# the build does not seem to work all that
	# well with parallel make
	make || die
}

src_install () {
	# The install location is taken care of by the
	# configure script.
	make DESTDIR=${D} install || die

	#nhc has really weir configure system:
	#it seems to setup hmakerc to point to the build position ignoring --prefix
	#just need to copy a proper hmakerc over here
	cd ${S}
	MACHINE=`script/harch`
	cp ${FILESDIR}/hmakerc ${D}/usr/lib/hmake/${MACHINE}/
	
	#install docs and man pages manually
	dodoc README INSTALL COPYRIGHT
	doman man/*

	cd docs
	dohtml *
	docinto html/bugs
	dodoc bugs/*
	docinto html/examples
	dodoc examples/*
	docinto html/hat
	dohtml hat/*
	docinto html/hmake
	dodoc hmake
	docinto html/implementation-notes
	dohtml implementation-notes/*
	docinto html/libs
	dohtml libs/*
}
