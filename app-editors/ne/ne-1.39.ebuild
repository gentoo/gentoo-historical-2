# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-editors/ne/ne-1.39.ebuild,v 1.5 2005/01/21 00:19:22 swegener Exp $

DESCRIPTION="the nice editor, easy to use for the beginner and powerful for the wizard"
HOMEPAGE="http://ne.dsi.unimi.it/"
SRC_URI="http://ne.dsi.unimi.it/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="x86 ~ppc ~ppc64 ~amd64"
IUSE=""

RDEPEND=">=sys-libs/ncurses-5.2"
DEPEND="${RDEPEND}
	dev-lang/perl"

PROVIDE="virtual/editor"

src_compile() {
	emake \
		-j1 -C src ne \
		CFLAGS="${CFLAGS} -DNODEBUG -D_POSIX_C_SOURCE=199506L" \
		LIBS="-lncurses" || die "emake failed"
}

src_install() {
	gunzip doc/ne.info*.gz || die "gunzip failed"

	dobin src/ne || die "dobin failed"
	doman doc/ne.1 || die "doman failed"
	doinfo doc/*.info* || die "doinfo failed"
	dohtml doc/*.html || die "dohtml failed"
	dodoc \
		CHANGES README \
		doc/*.txt doc/*.ps doc/*.pdf doc/*.texinfo doc/default.* \
		|| die "dodoc failed"
}
