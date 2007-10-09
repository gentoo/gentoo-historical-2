# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sys-devel/kgcc64/kgcc64-4.1.2.ebuild,v 1.3 2007/10/09 05:48:44 jer Exp $

case ${CHOST} in
	hppa*)    CTARGET=hppa64-${CHOST#*-};;
	mips*)    CTARGET=${CHOST/mips/mips64};;
	powerpc*) CTARGET=${CHOST/powerpc/powerpc64};;
	s390*)    CTARGET=${CHOST/s390/s390x};;
	sparc*)   CTARGET=${CHOST/sparc/sparc64};;
	i?86*)    CTARGET=x86_64-${CHOST#*-};;
esac
export CTARGET
TOOLCHAIN_ALLOWED_LANGS="c"
GCC_TARGET_NO_MULTILIB=true

PATCH_VER="1.0.1"
ETYPE="gcc-compiler"
GCC_FILESDIR=${FILESDIR/${PN}/gcc}

inherit toolchain eutils

DESCRIPTION="64bit kernel compiler"

KEYWORDS="-* hppa ~mips ~ppc ~s390 sparc ~x86"

# unlike every other target, hppa has not unified the 32/64 bit
# ports in binutils yet
DEPEND="hppa? ( sys-devel/binutils-hppa64 )
	!sys-devel/gcc-hppa64
	!sys-devel/gcc-mips64
	!sys-devel/gcc-powerpc64
	!sys-devel/gcc-sparc64"

src_unpack() {
	toolchain_src_unpack

	# Fix cross-compiling
	epatch "${GCC_FILESDIR}"/4.1.0/gcc-4.1.0-cross-compile.patch
}

src_install() {
	toolchain_src_install

	local x
	for x in gcc cpp ; do
		newbin "${FILESDIR}"/wrapper ${CTARGET%%-*}-linux-${x}
		dosed "s:TARGET:${CTARGET}-${x}:" /usr/bin/${CTARGET%%-*}-linux-${x}
	done
}
