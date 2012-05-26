# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-util/fix-la-relink-command/fix-la-relink-command-0.1.1.ebuild,v 1.2 2012/05/26 10:22:49 tetromino Exp $

EAPI="4"

DESCRIPTION="Helps prevent .la files from relinking to libraries outside a build tree"
HOMEPAGE="http://dev.gentoo.org/~tetromino/distfiles/${PN}"
SRC_URI="http://dev.gentoo.org/~tetromino/distfiles/${PN}/${P}.tar.xz"

LICENSE="|| ( Artistic GPL-1 GPL-2 GPL-3 )"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~ia64 ~ppc ~ppc64 ~sparc ~x86"
IUSE=""

RDEPEND="dev-lang/perl
	virtual/perl-Getopt-Long"
DEPEND="${RDEPEND}
	app-arch/xz-utils"

src_install() {
	dobin ${PN}
	doman ${PN}.1
	dodoc NEWS
}
