# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-util/kelbt/kelbt-0.13.ebuild,v 1.1 2009/05/19 19:45:20 flameeyes Exp $

EAPI=2

inherit eutils

DESCRIPTION="A backtracking LR parser by the author of Ragel"
HOMEPAGE="http://www.complang.org/kelbt/"
SRC_URI="http://www.complang.org/kelbt/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86-fbsd"
IUSE="vim-syntax"

RDEPEND=""

# Tests are currently broken
RESTRICT=test

src_prepare() {
	find "${S}" -iname "Makefile*" -exec sed -i \
		-e '/\$(CXX)/s:CFLAGS:CXXFLAGS:' \
		{} \;
}

src_test() {
	cd "${S}"/test
	./runtests || die "tests failed"
}

src_install() {
	dobin kelbt || die
	dodoc TODO CREDITS ChangeLog || die

	if use vim-syntax; then
		insinto /usr/share/vim/vimfiles/syntax
		doins ${PN}.vim || die
	fi
}
