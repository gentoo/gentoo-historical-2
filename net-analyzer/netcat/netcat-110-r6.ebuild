# Copyright 1999-2004 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-analyzer/netcat/netcat-110-r6.ebuild,v 1.3 2004/06/25 03:21:59 agriffis Exp $

inherit eutils gcc flag-o-matic

MY_P=nc${PV}
DESCRIPTION="the network swiss army knife"
HOMEPAGE="http://www.atstake.com/research/tools/network_utilities/"
SRC_URI="http://www.atstake.com/research/tools/network_utilities/${MY_P}.tgz
	ftp://sith.mimuw.edu.pl/pub/users/baggins/IPv6/nc-v6-20000918.patch.gz
	mirror://gentoo/${PF}-gentoo-deb-patches.tbz2"

LICENSE="as-is"
SLOT="0"
KEYWORDS="~x86 ~ppc ~sparc ~alpha ~arm ~hppa ~amd64"
IUSE="ipv6 static crypt GAPING_SECURITY_HOLE"

DEPEND="virtual/glibc
	crypt? ( dev-libs/libmix )"

src_unpack() {
	mkdir ${S}
	cd ${S}
	unpack ${MY_P}.tgz
	unpack ${PF}-gentoo-deb-patches.tbz2
	epatch ${DISTDIR}/nc-v6-20000918.patch.gz
	EPATCH_SUFFIX="patch" epatch ${S}/deb-patches/
	sed -i 's:#define HAVE_BIND:#undef HAVE_BIND:' netcat.c
	sed -i 's:#define FD_SETSIZE 16:#define FD_SETSIZE 1024:' netcat.c #34250
}

src_compile() {
	export XLIBS=""
	export XFLAGS="-DLINUX -DTELNET"
	use ipv6 && XFLAGS="${XFLAGS} -DINET6"
	use static && export STATIC="-static"
	use crypt && XFLAGS="${XFLAGS} -DAESCRYPT" && XLIBS="${XLIBS} -lmix"
	use GAPING_SECURITY_HOLE && XFLAGS="${XFLAGS} -DGAPING_SECURITY_HOLE"
	CC="$(gcc-getCC) ${CFLAGS}" make -e nc || die
}

src_install() {
	dobin nc || die "dobin failed"
	dodoc README README.Debian netcat.blurb README.aes-netcat
	doman nc.1
	docinto scripts
	dodoc scripts/*
}
