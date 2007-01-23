# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-util/cook/cook-2.24.ebuild,v 1.10 2007/01/23 18:28:44 nixnut Exp $

inherit eutils

DESCRIPTION="tool for constructing files; a drop in replacement for make"
HOMEPAGE="http://www.canb.auug.org.au/~millerp/cook/cook.html"
SRC_URI="http://www.canb.auug.org.au/~millerp/cook/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="ppc ~ppc-macos sparc x86"
IUSE=""

DEPEND="sys-devel/bison"

src_unpack() {
	unpack ${A}
	cd "${S}"
	epatch "${FILESDIR}"/${P}-bugfix.patch
}

src_compile() {
	econf || die "./configure failed"
	# doesn't seem to like parallel
	emake -j1 || die
}

src_install() {
	# we'll hijack the RPM_BUILD_ROOT variable which is intended for a
	# similiar purpose anyway
	make RPM_BUILD_ROOT="${D}" install || die
}
