# Copyright 1999-2004 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/x11-misc/xwit/xwit-3.4.ebuild,v 1.3 2004/06/24 22:46:44 agriffis Exp $

IUSE=""

DESCRIPTION="xwit (x window interface tool) is a hodge-podge collection of simple routines to call some of those X11 functions that don't already have any utility commands built around them."
HOMEPAGE="http://www.x.org/contrib/utilities/${P}.README"
SRC_URI="http://www.x.org/contrib/utilities/${P}.tar.gz"

LICENSE="as-is"
SLOT="0"
KEYWORDS="x86"

DEPEND="virtual/x11"

src_compile() {
	xmkmf || die "xmkmf failed"
	emake || die "Make failed"
}

src_install() {
	dobin xwit
	cp xwit.man xwit.1
	doman xwit.1
}
