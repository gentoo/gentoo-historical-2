# Copyright 1999-2004 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/x11-misc/xinput/xinput-1.2.ebuild,v 1.2 2004/07/09 23:55:12 mr_bones_ Exp $

DESCRIPTION="An utility to set XInput device parameters"
HOMEPAGE="ftp://ftp.x.org/contrib/utilities/${PN}.README"
SRC_URI="ftp://ftp.x.org/contrib/utilities/${P}.tar.gz"
LICENSE="as-is"

SLOT="0"
KEYWORDS="~x86 ~ppc"
IUSE=""
DEPEND="virtual/x11"

src_compile() {
	xmkmf -a || die
	emake CDEBUGFLAGS="${CDEBUGFLAGS}" || die
}

src_install() {
	make DESTDIR=${D} install install.man

	dodoc ChangeLog README
}
