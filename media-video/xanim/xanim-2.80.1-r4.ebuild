# Copyright 1999-2003 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-video/xanim/xanim-2.80.1-r4.ebuild,v 1.11 2003/02/13 13:37:08 vapier Exp $

LICENSE="XAnim"
SLOT="0"
KEYWORDS="x86 ppc sparc alpha"

_XA_CYUV_SPARC=xa1.0_cyuv_sparcELF.o
_XA_CVID_SPARC=xa2.0_cvid_sparcELF.o
_XA_IV32_SPARC=xa2.0_iv32_sparcELF.o
_XA_SPARC_EXT=.Z

_XA_CYUV_ALPHA=xa1.0_cyuv_linuxAlpha.o
_XA_CVID_ALPHA=xa2.0_cvid_linuxAlpha.o
_XA_IV32_ALPHA=xa2.0_iv32_linuxAlpha.o
_XA_ALPHA_EXT=.gz

_XA_CYUV_I386=xa1.0_cyuv_linuxELFg21.o
_XA_CVID_I386=xa2.0_cvid_linuxELFg21.o
_XA_IV32_I386=xa2.1_iv32_linuxELFg21.o
_XA_I386_EXT=.gz

_XA_CYUV_PPC=xa1.0_cyuv_linuxPPC.o
_XA_CVID_PPC=xa2.0_cvid_linuxPPC.o
_XA_IV32_PPC=xa2.0_iv32_linuxPPC.o
_XA_PPC_EXT=.Z

case $ARCH in
	sparc*)
			_XA_CYUV=$_XA_CYUV_SPARC
			_XA_CVID=$_XA_CVID_SPARC
			_XA_IV32=$_XA_IV32_SPARC
			_XA_EXT=$_XA_SPARC_EXT
			_XA_UNCOMPRESS=uncompress
			;;
   alpha)
            _XA_CYUV=$_XA_CYUV_ALPHA
            _XA_CVID=$_XA_CVID_ALPHA
            _XA_IV32=$_XA_IV32_ALPHA
            _XA_EXT=$_XA_ALPHA_EXT
            _XA_UNCOMPRESS=gunzip
            ;;
	ppc)
			_XA_CYUV=$_XA_CYUV_PPC
			_XA_CVID=$_XA_CVID_PPC
			_XA_IV32=$_XA_IV32_PPC
			_XA_EXT=$_XA_PPC_EXT
			_XA_UNCOMPRESS=uncompress
			;;
	*)
			_XA_CYUV=$_XA_CYUV_I386
			_XA_CVID=$_XA_CVID_I386
			_XA_IV32=$_XA_IV32_I386
			_XA_EXT=$_XA_I386_EXT
			_XA_UNCOMPRESS=gunzip
			;;
esac
			
A="xanim2801.tar.gz \
	${_XA_CYUV_SPARC}${_XA_SPARC_EXT} ${_XA_CVID_SPARC}${_XA_SPARC_EXT} \
	${_XA_IV32_SPARC}${_XA_SPARC_EXT} \
    ${_XA_CYUV_ALPHA}${_XA_ALPHA_EXT} ${_XA_CVID_ALPHA}${_XA_ALPHA_EXT} \
    ${_XA_IV32_ALPHA}${_XA_ALPHA_EXT} \
	${_XA_CYUV_I386}${_XA_I386_EXT} ${_XA_CVID_I386}${_XA_I386_EXT} \
	${_XA_IV32_I386}${_XA_I386_EXT} \
	${_XA_CYUV_PPC}${_XA_PPC_EXT} ${_XA_CVID_PPC}${_XA_PPC_EXT} \
	${_XA_IV32_PPC}${_XA_PPC_EXT}"
S=${WORKDIR}/xanim2801
DESCRIPTION="XAnim"
SRC_URI="ftp://xanim.va.pubnix.com/xanim2801.tar.gz
	 ftp://xanim.va.pubnix.com/modules/${_XA_CYUV_SPARC}${_XA_SPARC_EXT}
	 ftp://xanim.va.pubnix.com/modules/${_XA_CVID_SPARC}${_XA_SPARC_EXT}
	 ftp://xanim.va.pubnix.com/modules/${_XA_IV32_SPARC}${_XA_SPARC_EXT}
     ftp://xanim.va.pubnix.com/modules/${_XA_CYUV_ALPHA}${_XA_ALPHA_EXT}
     ftp://xanim.va.pubnix.com/modules/${_XA_CVID_ALPHA}${_XA_ALPHA_EXT}
     ftp://xanim.va.pubnix.com/modules/${_XA_IV32_ALPHA}${_XA_ALPHA_EXT}
	 ftp://xanim.va.pubnix.com/modules/${_XA_CYUV_PPC}${_XA_PPC_EXT}
	 ftp://xanim.va.pubnix.com/modules/${_XA_CVID_PPC}${_XA_PPC_EXT}
	 ftp://xanim.va.pubnix.com/modules/${_XA_IV32_PPC}${_XA_PPC_EXT}
	 ftp://xanim.va.pubnix.com/modules/${_XA_CYUV_I386}${_XA_I386_EXT}
	 ftp://xanim.va.pubnix.com/modules/${_XA_CVID_I386}${_XA_I386_EXT}
	 ftp://xanim.va.pubnix.com/modules/${_XA_IV32_I386}${_XA_I386_EXT}"
HOMEPAGE="http://xanim.va.pubnix.com"

DEPEND="virtual/x11
	>=sys-libs/zlib-1.1.3
	ppc? ( app-arch/ncompress )
	sparc? ( app-arch/ncompress )
	? ( app-arch/ncompress )"

  	
src_unpack() {
	unpack xanim2801.tar.gz
	mkdir ${S}/mods
	cd ${S}/mods
	cp ${DISTDIR}/${_XA_CYUV}${_XA_EXT} .
	$_XA_UNCOMPRESS ${_XA_CYUV}${_XA_EXT}
	cp ${DISTDIR}/${_XA_CVID}${_XA_EXT} .
	$_XA_UNCOMPRESS ${_XA_CVID}${_XA_EXT}
	cp ${DISTDIR}/${_XA_IV32}${_XA_EXT} .
	$_XA_UNCOMPRESS ${_XA_IV32}${_XA_EXT}
	# -O higher than -O2 breaks for GCC3.1
	CFLAGS=${CFLAGS//-O[0-9]/-O2}
	sed -e "s:-O2:${CFLAGS}:" ${FILESDIR}/Makefile > ${S}/Makefile
}

src_compile() {
	make XA_IV32_LIB=mods/${_XA_CYUV} XA_CVID_LIB=mods/${_XA_CVID} \
		XA_CYUV_LIB=mods/${_XA_IV32} || die
}

src_install () {
	into /usr
	dobin xanim
	newman docs/xanim.man xanim.1
	insinto /usr/lib/xanim/mods
	doins mods/*
	dodoc README
	dodoc docs/README.* docs/*.readme docs/*.doc
}
