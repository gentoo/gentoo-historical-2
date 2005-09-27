# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-libs/netpbm/netpbm-10.29-r1.ebuild,v 1.2 2005/09/27 10:04:15 ticho Exp $

inherit flag-o-matic toolchain-funcs eutils

DESCRIPTION="A set of utilities for converting to/from the netpbm (and related) formats"
HOMEPAGE="http://netpbm.sourceforge.net/"
SRC_URI="mirror://sourceforge/${PN}/${P}.tgz
	mirror://gentoo/${P}-manpages.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="svga jpeg tiff png zlib"

DEPEND="jpeg? ( >=media-libs/jpeg-6b )
	tiff? ( >=media-libs/tiff-3.5.5 )
	png? ( >=media-libs/libpng-1.2.1 )
	zlib? ( sys-libs/zlib )
	svga? ( media-libs/svgalib )
	media-libs/jbigkit
	media-libs/jasper
	media-libs/urt"

netpbm_config() {
	use $1 && echo ${2:-lib$1.so} || echo NONE
}

src_unpack() {
	unpack ${A}
	cd "${S}"

	epatch "${FILESDIR}"/netpbm-10.29-anytopnm.patch #105127
	epatch "${FILESDIR}"/netpbm-10.29-pnmtopng-alpha-check.patch #104434
	epatch "${FILESDIR}"/netpbm-10.29-build.patch

	rm -f configure
	cp Makefile.config.in Makefile.config
	cat >> Makefile.config <<-EOF
	# Gentoo toolchain options
	CC = $(tc-getCC)
	CC_FOR_BUILD = $(tc-getBUILD_CC)
	AR = $(tc-getAR)
	RANLIB = $(tc-getRANLIB)
	STRIPFLAG =
	CFLAGS_SHLIB = -fPIC

	# Gentoo build options
	TIFFLIB = $(netpbm_config tiff)
	JPEGLIB = $(netpbm_config jpeg)
	PNGLIB = $(netpbm_config png)
	ZLIB = $(netpbm_config zlib libz.so)
	LINUXSVGALIB = $(netpbm_config svga libvga.so)

	# Use system versions instead of bundled
	JBIGLIB = libjbig.a
	JBIGHDR_DIR =
	JASPERLIB = libjasper.so
	JASPERHDR_DIR =
	URTLIB = librle.a
	URTHDR_DIR = /usr/include/urt
	EOF

	# Sparc support ...
	replace-flags -mcpu=ultrasparc "-mcpu=v8 -mtune=ultrasparc"
	replace-flags -mcpu=v9 "-mcpu=v8 -mtune=v9"
}

src_install() {
	make package pkgdir="${D}"/usr || die "make package failed"

	[[ $(get_libdir) != "lib" ]] && mv "${D}"/usr/lib "${D}"/usr/$(get_libdir)

	# Remove cruft that we don't need, and move around stuff we want
	rm -f "${D}"/usr/bin/{doc.url,manweb}
	rm -rf "${D}"/usr/man/web
	rm -rf "${D}"/usr/link
	rm -f "${D}"/usr/{README,VERSION,config_template,pkginfo}
	dodir /usr/share
	mv "${D}"/usr/man "${D}"/usr/share/
	mv "${D}"/usr/misc "${D}"/usr/share/netpbm

	dodoc README
	cd doc
	GLOBIGNORE='*.html:.*' dodoc *
	dohtml -r .

	cd "${WORKDIR}"/${P}-manpages
	doman *.[0-9]
	dodoc README* gen-netpbm-manpages
}
