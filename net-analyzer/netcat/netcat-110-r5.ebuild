# Copyright 1999-2004 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-analyzer/netcat/netcat-110-r5.ebuild,v 1.5 2004/07/01 20:02:16 squinky86 Exp $

inherit eutils gcc

MY_P=nc${PV}
DESCRIPTION="the network swiss army knife"
HOMEPAGE="http://www.atstake.com/research/tools/network_utilities/"
SRC_URI="http://www.atstake.com/research/tools/network_utilities/${MY_P}.tgz
	ipv6?( ftp://sith.mimuw.edu.pl/pub/users/baggins/IPv6/nc-v6-20000918.patch.gz )
	mirror://gentoo/${P}-deb-patches.tbz2"

LICENSE="as-is"
SLOT="0"
KEYWORDS="x86 ppc sparc alpha arm hppa amd64"
IUSE="ipv6 static GAPING_SECURITY_HOLE"

DEPEND="virtual/libc"

S=${WORKDIR}/nc-${PV}

src_unpack() {
	mkdir ${S}
	cd ${S}
	unpack ${MY_P}.tgz
	unpack ${P}-deb-patches.tbz2
	use ipv6 \
		&& epatch ${DISTDIR}/nc-v6-20000918.patch.gz && rm deb-patches/*_noipv6.patch \
		|| rm deb-patches/*_ipv6.patch
	EPATCH_SUFFIX="patch"
	epatch ${S}/deb-patches/
	echo "#define arm arm_timer" >> generic.h
	sed -i 's:#define HAVE_BIND:#undef HAVE_BIND:' netcat.c
	sed -i 's:#define FD_SETSIZE 16:#define FD_SETSIZE 1024:' netcat.c #34250
}

src_compile() {
	export XFLAGS="-DLINUX -DTELNET"
	use ipv6 && XFLAGS="${XFLAGS} -DINET6"
	use static && export STATIC="-static"
	use GAPING_SECURITY_HOLE && XFLAGS="${XFLAGS} -DGAPING_SECURITY_HOLE"
	CC="$(gcc-getCC) ${CFLAGS}" make -e nc || die
}

src_install() {
	dobin nc || die "dobin failed"
	dodoc README README.Debian netcat.blurb
	doman nc.1
	docinto scripts
	dodoc scripts/*
}
