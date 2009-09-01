# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-util/cweb/cweb-3.64-r1.ebuild,v 1.1 2009/09/01 17:50:05 jer Exp $

EAPI="2"

inherit eutils toolchain-funcs

S=${WORKDIR}
DESCRIPTION="Knuth's and Levy's C/C++ documenting system"
SRC_URI="ftp://labrea.stanford.edu/pub/cweb/cweb-${PV}.tar.gz"
HOMEPAGE="http://www-cs-faculty.stanford.edu/~knuth/cweb.html"

SLOT="0"
LICENSE="BSD"
KEYWORDS="~amd64 ~ppc ~sparc ~x86"
IUSE=""

DEPEND="virtual/libc
	!app-text/tetex
	!app-text/texlive-core
	!app-text/ptex"

src_prepare() {
	epatch "${FILESDIR}/${P}-make.patch"
}

src_compile() {
	tc-export CC
	# bug #258130
	emake -j1 all CFLAGS="${CFLAGS}" LINKFLAGS="${LDFLAGS}" || die
}

src_install () {
	dobin ctangle cweave
	doman cweb.1
	dodoc README cwebman.tex
	dodir /usr/share/texmf/tex/generic
	insinto /usr/share/texmf/tex/generic
	doins cwebmac.tex
	dodir /usr/lib/cweb
	insinto /usr/lib/cweb
	doins c++lib.w
	dodir /usr/share/emacs/site-lisp/
	insinto /usr/share/emacs/site-lisp/
	doins cweb.el
}

# Going to use this, just to make sure.  May convert to a latex-package later.
pkg_postinst() {
	texconfig rehash
}
