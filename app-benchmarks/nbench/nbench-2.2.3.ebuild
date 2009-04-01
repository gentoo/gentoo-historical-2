# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-benchmarks/nbench/nbench-2.2.3.ebuild,v 1.8 2009/04/01 14:56:27 jer Exp $

inherit eutils toolchain-funcs

MY_P="${PN}-byte-${PV}"
DESCRIPTION="Linux/Unix of release 2 of BYTE Magazine's BYTEmark benchmark"
HOMEPAGE="http://www.tux.org/~mayer/linux/bmark.html"
SRC_URI="http://www.tux.org/~mayer/linux/${MY_P}.tar.gz"

LICENSE="freedist"
SLOT="0"
KEYWORDS="alpha amd64 hppa ~mips ppc ppc64 sh sparc x86"
IUSE=""

S=${WORKDIR}/${MY_P}

src_unpack() {
	unpack ${A}
	cd "${S}"

	epatch "${FILESDIR}/${P}-Makefile.patch"
}

src_compile() {
	sed -i -e 's:$compiler -v\( 2>&1 | sed -e "/version/!d"\|\):$compiler -dumpversion:' sysinfo.sh || die
	sed -i -e 's:inpath="NNET.DAT":inpath="/usr/share/nbench/NNET.DAT":' nbench1.h || die

	make LINKFLAGS="${LDFLAGS}" CC=$(tc-getCC) CFLAGS="${CFLAGS}" || die "make failed"
}

src_install() {
	dobin nbench
	insinto /usr/share/nbench
	doins NNET.DAT

	dodoc Changes README* bdoc.txt
}
