# Copyright 1999-2003 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-libs/libgd/libgd-1.8.4-r2.ebuild,v 1.4 2003/07/11 15:05:30 aliz Exp $

MY_P=${P/lib/}
S=${WORKDIR}/${MY_P}
DESCRIPTION="A graphics library for fast image creation"
SRC_URI="http://www.boutell.com/gd/http/${MY_P}.tar.gz"
HOMEPAGE="http://www.boutell.com/gd/"

SLOT="0"
LICENSE="as-is | BSD"
KEYWORDS="x86 ~ppc sparc hppa"
IUSE="X truetype freetype-version-1"

DEPEND="media-libs/libpng
	media-libs/jpeg
	X? ( virtual/x11 )
	freetype-version-1? ( =media-libs/freetype-1* ) :
		( truetype? ( =media-libs/freetype-2* ) )"

src_unpack() {
	unpack ${A}
	cd ${S}

	local compopts
	local libsopts
	local incopts

	use alpha \
		&& [ "${CC}" == "ccc" ] \
		&& epatch ${FILESDIR}/gd-${PV}-dec-alpha-compiler.diff

	use X \
		&& compopts="${compopts} -DHAVE_XPM" \
		&& libsopts="${libsopts} -lXpm -lX11"

	compopts="${compopts} -DHAVE_LIBPNG -DHAVE_LIBJPEG"
	libsopts="${libsopts} -lpng -ljpeg"

	if [ `use freetype-version-1` ] ; then
		compopts="${compopts} -DHAVE_LIBTTF"
		libsopts="${libsopts} -lttf"
		incopts="-I/usr/include/freetype"
	elif [ `use truetype` ] ; then
		compopts="${compopts} -DHAVE_LIBFREETYPE"
		libsopts="${libsopts} -lfreetype"
		incopts="-I/usr/include/freetype2"
	fi

	mv Makefile Makefile.old || die
	sed -e "s:^\(CFLAGS\)=.*:\1=${CFLAGS} ${compopts} :" \
		-e "s:^\(LIBS\)=.*:\1=-lm -lgd -lz ${libsopts}:" \
		-e "s:^\(INCLUDEDIRS\)=:\1=${incopts} :" \
		-e "s:\(COMPILER=\)gcc:\1${CC:-gcc}:" \
		Makefile.old > Makefile || die
}

src_compile() {
	emake || die
}

src_install() {
	dodir /usr/{bin,lib,include/gd-1}
	make \
		INSTALL_LIB=${D}/usr/lib \
		INSTALL_BIN=${D}/usr/bin \
		INSTALL_INCLUDE=${D}/usr/include/gd-1 \
		install || die
	preplib /usr

	dodoc readme.txt
	dohtml -r ./

	# now make it slotable
	mv ${D}/usr/lib/libgd{,1}.a
	if `has_version =media-libs/libgd-2*` ; then
		rm -rf ${D}/usr/bin
	else
		dosym libgd1.a /usr/lib/libgd.a
		cd ${D}/usr/include/gd-1/
		for f in * ; do
			dosym gd-1/${f} /usr/include/${f}
		done
	fi
}
