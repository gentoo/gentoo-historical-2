# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-util/ragel/ragel-6.6-r1.ebuild,v 1.3 2011/03/07 12:05:27 armin76 Exp $

EAPI="3"

inherit eutils

DESCRIPTION="Compiles finite state machines from regular languages into executable code."
HOMEPAGE="http://www.complang.org/ragel/"
SRC_URI="http://www.complang.org/ragel/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~hppa ~ia64 ~ppc ~ppc64 ~s390 ~sh ~sparc ~x86 ~x86-fbsd ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~x86-macos ~x64-solaris ~x86-solaris"
IUSE="vim-syntax"

DEPEND=""
RDEPEND=""

# We need to get the txl language in Portage to have the tests :(
RESTRICT=test

src_prepare() {
	epatch "${FILESDIR}/${P}-ruby-1.9.2.patch"
}

src_configure() {
	econf --docdir="${EPREFIX}"/usr/share/doc/${PF} || die "econf failed"
}

src_test() {
	cd "${S}"/test
	./runtests.in || die
}

src_install() {
	emake DESTDIR="${D}" install || die "make install failed"
	dodoc ChangeLog CREDITS README TODO || die "dodoc failed"

	if use vim-syntax; then
		insinto /usr/share/vim/vimfiles/syntax
		doins ragel.vim || die "doins ragel.vim failed"
	fi
}
