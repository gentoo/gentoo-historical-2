# Copyright 1999-2004 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-util/cook/cook-2.24.ebuild,v 1.1 2004/04/01 00:51:52 karltk Exp $

DESCRIPTION="tool for constructing files; a drop in replacement for make"
SRC_URI="http://www.canb.auug.org.au/~millerp/cook/${P}.tar.gz"
HOMEPAGE="http://www.canb.auug.org.au/~millerp/cook/cook.html"

SLOT="0"
LICENSE="GPL-2"
KEYWORDS="~x86 ~sparc"

DEPEND="sys-devel/bison"

src_compile() {
	econf || die "./configure failed"
	make || die	# doesn't seem to like emake
}

src_install() {
	# we'll hijack the RPM_BUILD_ROOT variable which is intended for a 
	# similiar purpose anyway
	make RPM_BUILD_ROOT=${D} install || die
}
