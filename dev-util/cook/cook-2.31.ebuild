# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-util/cook/cook-2.31.ebuild,v 1.3 2010/01/15 21:24:15 fauli Exp $

inherit eutils

DESCRIPTION="tool for constructing files; a drop in replacement for make"
HOMEPAGE="http://www.canb.auug.org.au/~millerp/cook/cook.html"
SRC_URI="http://miller.emu.id.au/pmiller/software/cook/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~sparc ~x86 ~amd64-linux ~x86-linux ~ppc-macos"
IUSE=""

DEPEND="sys-devel/bison"
RDEPEND=""

src_compile() {
	econf || die "./configure failed"
	# doesn't seem to like parallel
	emake -j1 || die
}

src_install() {
	# we'll hijack the RPM_BUILD_ROOT variable which is intended for a
	# similiar purpose anyway
	# bug #295821
	emake -j1 RPM_BUILD_ROOT="${D}" install || die
}
