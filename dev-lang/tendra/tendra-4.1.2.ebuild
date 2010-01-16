# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-lang/tendra/tendra-4.1.2.ebuild,v 1.2 2010/01/16 10:38:29 truedfx Exp $

inherit eutils flag-o-matic multilib toolchain-funcs

DESCRIPTION="A C/C++ compiler initially developed by DERA"
HOMEPAGE="http://www.tendra.org/
	http://www.ten15.org/"
SRC_URI="ftp://ftp.allbsd.org/pub/TenDRA/releases/tendra/TenDRA-${PV}.tar.bz2
	mirror://gentoo/${P}-misc.patch.bz2
	mirror://gentoo/${P}-minix.patch.bz2
	http://dev.gentoo.org/~truedfx/${P}-r1-misc.patch.bz2
	http://dev.gentoo.org/~truedfx/${P}-minix.patch.bz2"

LICENSE="as-is"
SLOT="0"
KEYWORDS="-* ~amd64 ~x86"
IUSE=""

DEPEND=""
# Both tendra and tinycc install /usr/bin/tcc
RDEPEND="!dev-lang/tcc"

S=${WORKDIR}/TenDRA-${PV}

pkg_setup() {
	use amd64 && multilib_toolchain_setup x86
}

src_unpack() {
	unpack TenDRA-${PV}.tar.bz2
	cd "${S}"
	epatch "${DISTDIR}"/${P}-r1-misc.patch.bz2
	epatch "${DISTDIR}"/${P}-minix.patch.bz2
}

src_compile() {
	tc-export CC
	append-flags -D_XOPEN_SOURCE=500

	mkdir -p build/bin build/lib/TenDRA build/share/man

	PREFIX=${S}/build CCOPTS=${CFLAGS} \
	sh INSTALL || die "compilation failed"
}

src_install() {
	cp -R build "${D}"/usr || die "copying failed"

	DESTDIR=${D} PREFIX=/usr BUILD_COMMON=false BUILD_MACHINE=false \
	sh INSTALL || die "updating failed"
}
