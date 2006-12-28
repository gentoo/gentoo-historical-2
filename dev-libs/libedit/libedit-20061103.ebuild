# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-libs/libedit/libedit-20061103.ebuild,v 1.2 2006/12/28 16:18:56 flameeyes Exp $

inherit eutils toolchain-funcs

DESCRIPTION="BSD replacement for libreadline"
HOMEPAGE="http://cvsweb.netbsd.org/bsdweb.cgi/src/lib/libedit/"
SRC_URI="mirror://gentoo/${P}.tar.bz2"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~hppa ~ia64 ~m68k ~mips ~ppc ~ppc64 ~s390 ~sh ~x86 ~x86-fbsd"
IUSE="elibc_glibc"

DEPEND="sys-libs/ncurses
	!<=sys-freebs/freebsd-lib-6.2_rc1"

S=${WORKDIR}/netbsd-cvs

src_unpack() {
	unpack ${A}
	cd "${S}"

	epatch "${FILESDIR}"/${PN}-20061103-debian-to-gentoo.patch

	if use elibc_glibc; then
		mv "${WORKDIR}"/glibc-*/*.c .
		epatch "${FILESDIR}/${P}-glibc.patch"
	fi

	# FreeBSD's __weak_reference macro differs from NetBSD's
	epatch "${FILESDIR}/${P}-freebsd.patch"
}

src_compile() {
	emake -j1 .depend || die "depend"
	emake || die "make"
}

src_install() {
	into /
	dolib.so libedit.so || die "dolib.so"
	into /usr
	dolib.a libedit.a || die "dolib.a"
	insinto /usr/include
	doins histedit.h || die "doins histedit.h"
	insinto /usr/include/libedit
	doins readline/readline.h || die "doins readline.h"
	doman *.[35]

	gen_usr_ldscript libedit.so
}
