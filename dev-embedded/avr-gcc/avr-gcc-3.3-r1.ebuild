# Copyright 1999-2004 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-embedded/avr-gcc/avr-gcc-3.3-r1.ebuild,v 1.1 2004/03/07 19:25:57 pappy Exp $

DESCRIPTION="The GNU C compiler for the AVR microcontroller architecture"

# Homepage, not used by Portage directly but handy for developer reference

HOMEPAGE="http://sources.redhat.com/binutils"


S="${WORKDIR}/gcc-3.3"

A="gcc-3.3.tar.bz2"

SRC_URI="http://ftp.gnu.org/gnu/gcc/${A}"

LICENSE="GPL-2"

SLOT="0"

KEYWORDS="x86"
IUSE=""

INSTALLDIR=/usr
MANDIR=/usr/share/man
INFODIR=/usr/share/info

# Build-time dependencies, such as
#    ssl? ( >=openssl-0.9.6b )
#    >=perl-5.6.1-r1
# It is advisable to use the >= syntax show above, to reflect what you
# had installed on your system when you tested the package.  Then
# other users hopefully won't be caught without the right version of
# a dependency.
DEPEND="virtual/glibc dev-embedded/avr-binutils"

# Run-time dependencies, same as DEPEND if RDEPEND isn't defined:
#RDEPEND=""

src_compile() {
	pwd
	./configure \
		--host=${CHOST} \
		--target=avr \
		--prefix=${INSTALLDIR} \
		--enable-languages=c \
		--infodir=${INFODIR} \
		--mandir=${MANDIR} || die "./configure failed"

	emake || die
}

src_install() {
       make prefix=${D}${INSTALLDIR} \
           mandir=${D}${MANDIR} \
           infodir=${D}${INFODIR} \
           install || die
						       
}
