# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-util/tig/tig-0.6.ebuild,v 1.3 2007/05/11 20:17:30 dertobi123 Exp $

DESCRIPTION="Tig: text mode interface for git"
HOMEPAGE="http://jonas.nitro.dk/tig/"
SRC_URI="http://jonas.nitro.dk/tig/releases/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~hppa ~ia64 ~mips ~ppc64 ~s390 ~sh ~sparc ~x86 ~x86-fbsd"

DEPEND="sys-libs/ncurses"
RDEPEND="${DEPEND}
		dev-util/git"

src_compile() {
	emake CFLAGS="${CFLAGS}" || die "emake failed"
}

src_install() {
	einstall || die "einstall failed"
	doman tig.1 tigrc.5
	dodoc manual.txt tigrc
	dohtml manual.html
}
