# Copyright 1999-2004 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-libs/libcaca/libcaca-0.9.ebuild,v 1.8 2004/06/02 02:52:42 lv Exp $

DESCRIPTION="A library that creates colored ASCII-art graphics"
HOMEPAGE="http://sam.zoy.org/projects/libcaca"
SRC_URI="http://sam.zoy.org/projects/${PN}/${P}.tar.gz"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="x86 ppc sparc ~alpha hppa amd64 ~ia64"
IUSE="ncurses slang doc imlib X"

DEPEND="ncurses? ( >=sys-libs/ncurses-5.3 )
	slang? ( >=sys-libs/slang-1.4.2 )
	doc? ( app-doc/doxygen )
	imlib? ( media-libs/imlib2 )
	X? ( virtual/x11 )"

src_compile() {
	# temp font fix #44128
	export VARTEXFONTS="${T}/fonts"
	econf \
	    `use_enable doc` \
	    `use_enable ncuses` \
	    `use_enable slang` \
	    `use_enable imlib imlib2` \
		`use_enable X x11` \
	    || die
	emake || die
	unset VARTEXFONTS
}

src_install() {
	make install DESTDIR=${D} || die
	dodoc AUTHORS BUGS ChangeLog NEWS NOTES README TODO
}
