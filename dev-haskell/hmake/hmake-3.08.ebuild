# Copyright 1999-2003 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-haskell/hmake/hmake-3.08.ebuild,v 1.3 2003/06/27 14:02:32 vapier Exp $

inherit base

DESCRIPTION="a make tool for Haskell programs"
HOMEPAGE="http://www.haskell.org/hmake/"
SRC_URI="http://www.cs.york.ac.uk/ftpdir/pub/haskell/hmake/${P}.tar.gz"

LICENSE="nhc98"
KEYWORDS="~x86"
SLOT="0"
IUSE="nhc98 readline"

# hmake can be build with either ghc or nhc98; we prefer ghc
# unless a use flag tells us otherwise
DEPEND="nhc98?        ( dev-lang/nhc98 ) : ( virtual/ghc )
	readline?     ( sys-libs/readline )"
RDEPEND="readline?    ( sys-libs/readline )
	virtual/glibc
	!nhc98?       ( dev-libs/gmp
			sys-libs/readline )"

src_compile() {
	local buildwith
	local arch

	if [ "`use nhc98`" ]; then
		buildwith="--buildwith=nhc98"
		# Makefile is erroneous; we need to fix it
		pushd hmake-3.07
			mv Makefile Makefile.orig
			sed -e "s/^TARGETS.*=/TARGETS = hmake-nhc hi-nhc/" \
				Makefile.orig > Makefile
		popd
	else
		buildwith="--buildwith=ghc"
	fi

	# package uses non-standard configure, therefore econf does
	# not work ...
	./configure \
		--prefix=/usr \
		--mandir=/usr/share/man/man1 \
		${buildwith} || die "./configure failed"
	
	if [ ! "`use readline`" ]; then
		arch="`script/harch`"
		# manually override readline configuration
		einfo "Disabling readline ..."
		echo "READLINE=\"\"" >> lib/${arch}/config
	fi

	# emake tested; does not work
	make || die "make failed"
}

src_install() {
	make DESTDIR=${D} install || die
	dohtml docs/hmake/*
}
