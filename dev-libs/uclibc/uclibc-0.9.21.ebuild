# Copyright 1999-2004 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-libs/uclibc/uclibc-0.9.21.ebuild,v 1.7 2004/07/02 04:56:31 eradicator Exp $

inherit eutils

MY_P="${P/ucl/uCl}"
DESCRIPTION="C library for developing embedded Linux systems"
HOMEPAGE="http://www.uclibc.org/"
SRC_URI="http://www.kernel.org/pub/linux/libs/uclibc/${MY_P}.tar.bz2"

LICENSE="LGPL-2"
SLOT="0"
KEYWORDS="x86 ~ppc ~sparc ~mips"

DEPEND="sys-devel/gcc"
PROVIDE="virtual/libc virtual/libc"

S=${WORKDIR}/${MY_P}

src_unpack() {
	unpack ${A}
	cd ${S}

	make defconfig || die "could not config"
	for def in UCLIBC_HAS_LOCALE DODEBUG DOASSERTS SUPPORT_LD_DEBUG SUPPORT_LD_DEBUG_EARLY ; do
		sed -i "s:${def}=y:# ${def} is not set:" .config
	done
	cp .config myconfig

	for f in `grep -Rl 'subst -g' *` ; do
		sed -i -e "/subst -g/s:-g:\\' -g \\':" ${f}
	done

	emake clean || die "could not clean"
}

src_compile() {
	mv myconfig .config
	make || die "could not make"
}

src_install() {
	make PREFIX=${D} install || die "install failed"
}
