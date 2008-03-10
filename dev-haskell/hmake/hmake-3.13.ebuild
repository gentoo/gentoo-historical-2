# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-haskell/hmake/hmake-3.13.ebuild,v 1.4 2008/03/10 22:42:35 araujo Exp $

inherit base eutils ghc-package

DESCRIPTION="A make tool for Haskell programs"
HOMEPAGE="http://www.haskell.org/hmake/"
SRC_URI="http://www.haskell.org/hmake/${P}.tar.gz"

LICENSE="nhc98"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~ppc64 ~sparc ~x86"
IUSE=""

DEPEND="!>=dev-lang/ghc-6.8
		sys-libs/readline
		>=sys-apps/sandbox-1.2.12"
RDEPEND="dev-lang/ghc
		sys-libs/readline"

# sandbox dependency due to bug #97441, #101433

# if using readline, hmake depends also on ncurses; but
# readline already has this dependency

src_unpack() {
	unpack ${A}

	# Fix the way hmake discovers the ghc version
	sed -i -e '/echo __GLASGOW_HASKELL__/,+2 c \
		touch ghcsym.hs; \
		$1 -E -cpp -optP-dM ghcsym.hs -o ghcsym.out; \
		grep __GLASGOW_HASKELL__ ghcsym.out | cut -d" " -f 3 > $2;' \
		"${S}/script/confhc"
}

src_compile() {
	# package uses non-standard configure, therefore econf does
	# not work ...
	READLINE='-package readline' ./configure \
		--prefix=/usr \
		--mandir=/usr/share/man/man1 \
		--buildwith="$(ghc-getghc)" \
		|| die "./configure failed"

	# emake tested; parallel make does not work
	emake -j1 || die "make failed"
}

src_install() {
	make DESTDIR="${D}" install || die "make install failed"
	dohtml docs/hmake/*
}
