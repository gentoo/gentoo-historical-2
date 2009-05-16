# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-util/ragel/ragel-6.4.ebuild,v 1.5 2009/05/16 14:15:09 flameeyes Exp $

inherit eutils

DESCRIPTION="Compiles finite state machines from regular languages into executable code."
HOMEPAGE="http://www.complang.org/ragel/"
SRC_URI="http://www.complang.org/ragel/${P}.tar.gz
	doc? ( http://www.complang.org/ragel/ragel-guide-${PV}.pdf )"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~ppc64 ~sparc ~x86 ~x86-fbsd"
IUSE="doc vim-syntax"

DEPEND=""
RDEPEND=""

src_unpack() {
	unpack ${A}
	cd "${S}"

	epatch "${FILESDIR}"/${P}-solaris.patch
}

src_compile() {
	econf || die "econf failed"
	emake || die "emake failed"
	emake -C doc ragel.1 || die "emake manpage failed"
}

src_install() {
	dobin ragel/ragel || die "dobin failed"
	doman doc/ragel.1 || die "doman failed"
	dodoc ChangeLog CREDITS README TODO || die "dodoc failed"

	if use doc; then
		insinto /usr/share/doc/"${PF}"
		newins "${DISTDIR}"/ragel-guide-${PV}.pdf "ragel-guide.pdf" || die "newins ragel-guide failed"
	fi

	if use vim-syntax; then
		insinto /usr/share/vim/vimfiles/syntax
		doins ragel.vim || die "doins ragel.vim failed"
	fi
}
