# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-text/yudit/yudit-2.6.ebuild,v 1.1.1.1 2005/11/30 10:06:58 chriswhite Exp $

DESCRIPTION="free (Y)unicode text editor for all unices"
SRC_URI="http://yudit.org/download/${P}.tar.gz"
HOMEPAGE="http://www.yudit.org/"

SLOT="0"
LICENSE="GPL-2"
KEYWORDS="x86 sparc"
IUSE=""

DEPEND="virtual/x11
	>=sys-devel/gettext-0.10"

src_compile() {
	econf || die
	make || die
}

src_install() {
	make DESTDIR=${D} install || die
}
