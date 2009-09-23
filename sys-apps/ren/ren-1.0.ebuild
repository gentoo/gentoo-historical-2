# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sys-apps/ren/ren-1.0.ebuild,v 1.22 2009/09/23 20:26:27 patrick Exp $

DESCRIPTION="Renames multiple files"
HOMEPAGE="http://freshmeat.net/projects/ren"
SRC_URI="http://www.ibiblio.org/pub/Linux/utils/file/${P}.tar.gz"

KEYWORDS="alpha amd64 ~mips ppc ppc64 sparc x86"
IUSE=""
SLOT="0"
LICENSE="as-is"

DEPEND=""

src_compile() {
	emake || die
}

src_install() {
	dobin ren
	dodoc README
	doman ren.1
}
