# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-misc/fdupes/fdupes-1.40.ebuild,v 1.12 2005/04/21 19:11:28 blubb Exp $

DESCRIPTION="identify/delete duplicate files residing within specified directories"
HOMEPAGE="http://netdial.caribe.net/~adrian2/fdupes.html"
SRC_URI="http://netdial.caribe.net/~adrian2/programs/${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="amd64 arm hppa ia64 ~mips ppc ppc64 s390 sparc x86"
IUSE=""

DEPEND=""

src_compile() {
	emake || die
}

src_install() {
	dobin fdupes || die
	doman fdupes.1
	dodoc CHANGES CONTRIBUTORS INSTALL README TODO
}
