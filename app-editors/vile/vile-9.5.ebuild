# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-editors/vile/vile-9.5.ebuild,v 1.2 2006/06/07 15:14:00 chutzpah Exp $

inherit eutils

DESCRIPTION="VI Like Emacs -- yet another full-featured vi clone"
HOMEPAGE="http://invisible-island.net/vile/"
SRC_URI="ftp://invisible-island.net/vile/vile-9.5.tgz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~ia64 ~ppc ~ppc-macos ~sparc ~x86"
IUSE="perl"

RDEPEND=">=sys-libs/ncurses-5.2
	perl? ( dev-lang/perl )"
DEPEND="${RDEPEND}
	sys-devel/flex"
PROVIDE="virtual/editor"

src_unpack() {
	unpack ${A}
	cd ${S}

	epatch "${FILESDIR}/${P}-define-LEAD-before-use.patch"
}

src_compile() {
	econf \
		--with-ncurses \
		$(use_with perl ) \
		|| die "configure failed"
	emake || die "emake failed"
}

src_install() {
	make DESTDIR="${D}" install || die "install failed"
	dodoc CHANGES* README* doc/*
}
