# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-text/diction/diction-1.02.ebuild,v 1.14 2006/06/01 13:33:34 seemant Exp $

DESCRIPTION="Diction and style checkers for english and german texts"
HOMEPAGE="http://www.gnu.org/software/diction/diction.html"
SRC_URI="http://ftp.gnu.org/gnu/diction/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="x86 ~sparc ~mips"
IUSE=""

DEPEND="sys-devel/gettext"
RDEPEND="virtual/libintl"

src_compile() {
	./configure --prefix=/usr ||die
	emake || die
}

src_install() {
	make prefix=${D}/usr install
}
