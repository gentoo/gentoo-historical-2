# Copyright 1999-2003 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-util/cweb/cweb-3.64.ebuild,v 1.3 2003/09/06 20:28:40 msterret Exp $

S=${WORKDIR}
DESCRIPTION="Knuth's and Levy's C/C++ documenting system"
SRC_URI="ftp://labrea.stanford.edu/pub/cweb/cweb-${PV}.tar.gz"
HOMEPAGE="http://www-cs-faculty.stanford.edu/~knuth/cweb.html"

SLOT="0"
LICENSE="BSD"
KEYWORDS="x86 sparc "

DEPEND="virtual/glibc"

src_compile() {
	#emake won't work, because cweave needs ctangle to compile
	make all CFLAGS="${CFLAGS}" LINKFLAGS="-s" || die
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
