# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-text/diction/diction-1.07.ebuild,v 1.2 2005/10/19 16:26:58 grobian Exp $

DESCRIPTION="Diction and style checkers for english and german texts"
HOMEPAGE="http://www.fsf.org/software/diction/diction.html"
SRC_URI="http://www.moria.de/~michael/diction/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~mips ~ppc ~ppc-macos ~sparc ~x86"
IUSE=""

DEPEND="sys-devel/gettext"

src_compile() {
	./configure --prefix=/usr ||die
	emake || die
}

src_install() {
	make prefix=${D}/usr install
}
