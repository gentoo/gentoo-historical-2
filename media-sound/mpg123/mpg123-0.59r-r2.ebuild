# Copyright 1999-2003 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-sound/mpg123/mpg123-0.59r-r2.ebuild,v 1.7 2003/09/07 00:06:06 msterret Exp $

S=${WORKDIR}/${P}

DESCRIPTION="Real Time mp3 player"
SRC_URI="http://www.mpg123.de/mpg123/${P}.tar.gz"
HOMEPAGE="http://www.mpg123.de/"

DEPEND="virtual/glibc
	sparc? ( media-libs/audiofile ) "

SLOT="0"
LICENSE="as-is"
KEYWORDS="x86 ppc sparc alpha hppa amd64"

src_unpack () {
	unpack ${A}
	cd ${S}
	patch -p1 < ${FILESDIR}/${P}-make-fix.diff
	patch -p1 < ${FILESDIR}/${P}-sparc.diff
	use alpha && patch -p1 < ${FILESDIR}/${P}-alpha.diff
	use hppa && patch -p0 < ${FILESDIR}/${P}-hppa.diff
	use amd64 && epatch ${FILESDIR}/${P}-amd64.diff
	cp Makefile Makefile.orig
	sed -e "s:-O2 -m486:${CFLAGS}:" \
		-e "s:-O2 -mcpu=ppc:${CFLAGS}:g" \
		-e "s:-O6:${CFLAGS}:" \
		Makefile.orig > Makefile
}

src_compile() {
	local MAKEOPT=""
	local MAKESTYLE=""

	SYSTEM_ARCH=`echo $ARCH |\
		sed -e s/[i]*.86/i386/ \
			-e s/sun.*/sparc/ \
			-e s/arm.*/arm/ \
			-e s/amd64/x86_64/ \
			-e s/sa110/arm/`

	if [ -z "$SYSTEM_ARCH" ]
	then
		SYSTEM_ARCH=`uname -m |\
		sed -e s/[i]*.86/i386/ -e s/arm.*/arm/ -e s/sa110/arm/`
	fi

	case $SYSTEM_ARCH in
	  ppc)
	   MAKESTYLE="-ppc";;
	  i386)
	   MAKESTYLE="-i486";;
	  sparc)
	   MAKESTYLE="-sparc";;
	  alpha)
	   MAKESTYLE="-alpha";;
	  hppa)
	   MAKESTYLE="-hppa";;
	  x86_64)
	   MAKESTYLE="-x86_64";;
	  arm)
	   ;;
	esac

	make linux${MAKESTYLE}${MAKEOPT} || die
}

src_install () {
	into /usr
	dobin mpg123
	doman mpg123.1
	dodoc BENCHMARKING BUGS CHANGES COPYING JUKEBOX README* TODO
}
