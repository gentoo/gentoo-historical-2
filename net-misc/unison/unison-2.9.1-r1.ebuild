# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-misc/unison/unison-2.9.1-r1.ebuild,v 1.5 2005/07/19 16:16:49 mattam Exp $

inherit eutils

IUSE="gtk"

DESCRIPTION="Two-way cross-platform file synchronizer"
HOMEPAGE="http://www.cis.upenn.edu/~bcpierce/unison/"
LICENSE="GPL-2"
SLOT="0"
KEYWORDS="x86 sparc ppc ~alpha ~amd64"

DEPEND=">=dev-lang/ocaml-3.04
	gtk? ( =dev-ml/lablgtk-1.2* )"
RDEPEND="gtk? ( =x11-libs/gtk+-1.2*
|| ( net-misc/x11-ssh-askpass net-misc/gtk2-ssh-askpass ) )"

SRC_URI="mirror://gentoo/${P}.tar.gz"

src_unpack() {
	unpack ${P}.tar.gz

	# Fix for ocaml-3.08 change in exported symbol names
	if has_version '>=ocaml-3.08'; then
		epatch ${FILESDIR}/ocaml-3.08-extnames.patch
	fi

	# Fix for coreutils change of tail syntax
	cd ${S}
	sed -i -e 's/tail -1/tail -n 1/' Makefile.OCaml
}

src_compile() {
	local myconf

	if use gtk; then
		myconf="$myconf UISTYLE=gtk"
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
