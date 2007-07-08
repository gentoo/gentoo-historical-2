# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-analyzer/netcat/netcat-110-r8.ebuild,v 1.11 2007/07/08 11:39:27 uberlord Exp $

inherit eutils toolchain-funcs flag-o-matic

PATCH_VER="1.0"
MY_P=nc${PV}
DESCRIPTION="the network swiss army knife"
HOMEPAGE="http://nc110.sourceforge.net/"
SRC_URI="mirror://sourceforge/nc110/${MY_P}.tgz
	ftp://sith.mimuw.edu.pl/pub/users/baggins/IPv6/nc-v6-20000918.patch.gz
	mirror://gentoo/${P}-patches-${PATCH_VER}.tar.bz2"

LICENSE="as-is"
SLOT="0"
KEYWORDS="alpha amd64 arm hppa ia64 m68k mips ppc ppc64 s390 sh sparc x86 ~x86-fbsd"
IUSE="crypt ipv6 static"

DEPEND="crypt? ( dev-libs/libmix )"

S=${WORKDIR}

src_unpack() {
	unpack ${MY_P}.tgz ${P}-patches-${PATCH_VER}.tar.bz2
	epatch "${DISTDIR}"/nc-v6-20000918.patch.gz patch
	sed -i 's:#define HAVE_BIND:#undef HAVE_BIND:' netcat.c
	sed -i 's:#define FD_SETSIZE 16:#define FD_SETSIZE 1024:' netcat.c #34250
}

src_compile() {
	export XLIBS=""
	export XFLAGS="-DLINUX -DTELNET -DGAPING_SECURITY_HOLE"
	use ipv6 && XFLAGS="${XFLAGS} -DINET6"
	use static && export STATIC="-static"
	use crypt && XFLAGS="${XFLAGS} -DAESCRYPT" && XLIBS="${XLIBS} -lmix"
	make -e CC="$(tc-getCC) ${CFLAGS}" nc || die
}

src_install() {
	dobin nc || die "dobin failed"
	dodoc README* netcat.blurb debian-*
	doman nc.1
	docinto scripts
	dodoc scripts/*
}
