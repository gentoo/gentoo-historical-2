# Copyright 1999-2003 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-libs/dietlibc/dietlibc-0.24.ebuild,v 1.1 2003/11/22 06:37:12 mr_bones_ Exp $

inherit eutils flag-o-matic

DESCRIPTION="A minimal libc"
HOMEPAGE="http://www.fefe.de/dietlibc/"
SRC_URI="mirror://kernel/linux/libs/${PN}/${P}.tar.bz2"

SLOT="0"
LICENSE="GPL-2"
KEYWORDS="~x86 ~sparc ~hppa ~amd64 ~alpha"

DEPEND=">=sys-apps/sed-4"

src_unpack() {
	unpack ${A} ; cd ${S}

	epatch ${FILESDIR}/${PV}-dirent-prototype.patch

	sed -i \
		-e "s:^CFLAGS.*:CFLAGS = ${CFLAGS}:" \
		-e "s:^prefix.*:prefix=/usr/diet:" \
		-e "s:^#DESTDIR=.*:DESTDIR=${D}:" Makefile || \
			die "sed Makefile failed"
}

src_compile() {
	filter-flags "-fstack-protector"
# Added by Jason Wever <weeve@gentoo.org>
# Fix for bug #27171.
# dietlibc assumes that if uname -m is sparc64, then gcc is 64 bit
# but this is not the case on Gentoo currently.

	if [ "${ARCH}" = "sparc" -a "${PROFILE_ARCH}" = "sparc64" ]; then
		cd ${S}
		/usr/bin/sparc32 make || die "make failed"
	else
		emake || die "emake failed"
	fi
}

src_install() {
	if [ "${ARCH}" = "sparc" -a "${PROFILE_ARCH}" = "sparc64" ]; then
		cd ${S}
		/bin/sparc32 make install || die "make install failed"
	else
		make install || die "make install failed"
	fi

	exeinto /usr/bin
	newexe bin-$(uname -m | sed -e 's/i[4-9]86/i386/' -e 's/armv[3-6][lb]/arm/')/diet-i diet || die "newexe failed"

	doman diet.1 || die "doman failed"
	dodoc AUTHOR BUGS CAVEAT CHANGES README THANKS TODO PORTING || \
		die "dodoc failed"
}
