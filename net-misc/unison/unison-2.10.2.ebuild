# Copyright 1999-2004 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-misc/unison/unison-2.10.2.ebuild,v 1.1 2004/09/25 21:05:24 mattam Exp $

inherit eutils

IUSE="gtk gtk2"

DESCRIPTION="Two-way cross-platform file synchronizer"
HOMEPAGE="http://www.cis.upenn.edu/~bcpierce/unison/"
LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~x86 ~ppc"

DEPEND=">=dev-lang/ocaml-3.04
	gtk? ( gtk2? ( >=dev-ml/lablgtk-2.2 ) !gtk2? ( =dev-ml/lablgtk-1.2* ) )"
RDEPEND="gtk? ( gtk2? ( >=dev-ml/lablgtk-2.2 ) !gtk2? ( =dev-ml/lablgtk-1.2* ) )"

SRC_URI="http://www.cis.upenn.edu/~bcpierce/unison/download/beta-test/${P}/${P}.tar.gz"

pkg_setup() {
	ewarn "This is a beta release, use at your very own risk"
}

src_unpack() {
	unpack ${P}.tar.gz

	# Fix for coreutils change of tail syntax
	cd ${S}
	sed -i -e 's/tail -1/tail -n 1/' Makefile.OCaml
}

src_compile() {
	local myconf

	if use gtk; then
		if use gtk2; then
			myconf="$myconf UISTYLE=gtk2"
		else
			myconf="$myconf UISTYLE=gtk"
		fi
	else
		myconf="$myconf UISTYLE=text"
	fi

	make $myconf CFLAGS="" || die
}

src_install () {
	# install manually, since it's just too much
	# work to force the Makefile to do the right thing.
	dobin unison
	dodoc BUGS.txt CONTRIB COPYING INSTALL NEWS \
	      README ROADMAP.txt TODO.txt
}
