# Copyright 1999-2003 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-video/mpeg2vidcodec/mpeg2vidcodec-12-r1.ebuild,v 1.7 2003/02/13 13:30:01 vapier Exp $

MY_P=${PN}_v${PV}
S=${WORKDIR}/mpeg2
DESCRIPTION="MPEG Library"
SRC_URI="ftp://ftp.mpeg.org/pub/mpeg/mssg/${MY_P}.tar.gz"
HOMEPAGE="http://www.mpeg.org"

DEPEND="virtual/glibc"

SLOT="0"
LICENSE="as-is"
KEYWORDS="x86 ~ppc"

src_unpack () {

  unpack ${A}
  cd ${S}
  cp Makefile Makefile.orig
  sed -e "s:-O2:${CFLAGS}:" Makefile.orig > Makefile

}
src_compile() {

	cd ${S}
	make || die

}

src_install () {

	cd ${S}
	into /usr
	dobin src/mpeg2dec/mpeg2decode
	dobin src/mpeg2enc/mpeg2encode
	dodoc README doc/*

}
