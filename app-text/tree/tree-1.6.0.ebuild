# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-text/tree/tree-1.6.0.ebuild,v 1.3 2011/08/24 19:30:34 maekke Exp $

EAPI=2
inherit toolchain-funcs flag-o-matic bash-completion

DESCRIPTION="Lists directories recursively, and produces an indented listing of files."
HOMEPAGE="http://mama.indstate.edu/users/ice/tree/"
SRC_URI="ftp://mama.indstate.edu/linux/tree/${P}.tgz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~alpha amd64 ~arm ~hppa ~ia64 ~m68k ~mips ~ppc ~ppc64 ~s390 ~sh ~sparc x86"
IUSE=""

src_prepare() {
	sed -i \
		-e 's:LINUX:__linux__:' tree.c \
		|| die "sed failed"
	mv doc/tree.1.fr doc/tree.fr.1
}

src_compile() {
	append-lfs-flags
	emake \
		CC="$(tc-getCC)" \
		CFLAGS="${CFLAGS}" \
		LDFLAGS="${LDFLAGS}" \
		XOBJS="$(use elibc_uclibc && echo strverscmp.o)" \
		|| die "emake failed"
}

src_install() {
	dobin tree || die "dobin failed"
	doman doc/tree*.1 || die
	dodoc CHANGES README* || die
	dobashcompletion "${FILESDIR}"/${PN}.bashcomp
}
