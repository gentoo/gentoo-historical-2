# Copyright 1999-2004 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/x11-plugins/wmbiff/wmbiff-0.4.15.ebuild,v 1.10 2004/06/24 23:05:24 agriffis Exp $

DESCRIPTION="WMBiff is a dock applet for WindowMaker which can monitor up to 5 mailboxes."
SRC_URI="mirror://sourceforge/wmbiff/${P}.tar.gz"
HOMEPAGE="http://sourceforge.net/projects/wmbiff/"

DEPEND="virtual/x11"

SLOT="0"
LICENSE="GPL-2"
KEYWORDS="x86 sparc amd64 ppc"
IUSE=""

src_compile() {
	cd ${S}
	econf || die "econf failed"
	emake || die
}

src_install () {
	einstall
	dodoc ChangeLog  FAQ NEWS  README  README.licq  TODO
}
