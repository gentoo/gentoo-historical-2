# Copyright 1999-2002 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-libs/netpbm/netpbm-10.11.5.ebuild,v 1.2 2003/02/14 17:14:39 lostlogic Exp $

IUSE="svga pic"

S=${WORKDIR}/${P}
DESCRIPTION="A set of utilities for converting to/from the netpbm (and related) formats"
SRC_URI="mirror://sourceforge/${PN}/${P}.tgz"
HOMEPAGE="http://netpbm.sourceforge.net/"

DEPEND=">=media-libs/jpeg-6b
	>=media-libs/tiff-3.5.5
	>=media-libs/libpng-1.2.1
	svga? ( media-libs/svgalib )"

SLOT="0"
LICENSE="GPL-2"
KEYWORDS="~x86 ~ppc ~sparc"

src_unpack() {
	unpack ${A}
	cd ${S}

	if [ ${ARCH} != "x86" ] ; then
			cfg="config"
	else
		if [ -n "`use svga`" ]
		then
			cfg="svga"
		else
			cfg="config"
		fi
	fi

	if [ -n "`use pic`" ]
	then
		CFLAGS="${CFLAGS} -fPIC"
	fi

	sed <${FILESDIR}/${PV}/Makefile.${cfg} >Makefile.config \
		-e "s|-O3|${CFLAGS}|"
}

src_compile() {
	MAKEOPTS="${MAKEOPTS} -j1"
	emake CC="${CC}" CXX="${CXX}"|| die
}

src_install () {
	make package pkgdir=${D}/usr/ || die
	
	dodir /usr/share
	rm -rf ${D}/usr/bin/doc.url
	rm -rf ${D}/usr/man/web
	rm -rf ${D}/usr/link
	rm -rf ${D}/usr/README
	rm -rf ${D}/usr/pkginfo	
	mv ${D}/usr/man/ ${D}/usr/share/man
#	mv ${D}/usr/misc/* ${D}/usr/lib
	rm -rf ${D}/usr/misc

	#dosym /usr/bin/gemtopnm /usr/bin/gemtopbm
	#dosym /usr/bin/pnmtoplainpnm /usr/bin/pnmnoraw
	
	#insinto /usr/include
	#doins pnm/{pam,pnm}.h ppm/{ppm,pgm,pbm}.h
	#doins pbmplus.h shhopt/shhopt.h
	dodoc COPYRIGHT.PATENT GPL_LICENSE.txt HISTORY \
		Netpbm.programming README* netpbm.lsm \
		doc/*
}

