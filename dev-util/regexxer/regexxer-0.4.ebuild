# Copyright 1999-2003 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-util/regexxer/regexxer-0.4.ebuild,v 1.2 2003/03/10 11:14:48 vladimir Exp $

DESCRIPTION="An interactive tool for performing search and replace operations"
HOMEPAGE="http://regexxer.sourceforge.net/"
LICENSE="GPL-2"

SRC_URI="mirror://sourceforge/regexxer/${P}.tar.gz"

IUSE=""
SLOT="0"
KEYWORDS="~x86 ~ppc"

DEPEND=">=x11-libs/gtkmm-2.0.0
		>=dev-libs/libpcre-3.9-r2"


src_compile() {
	econf || die "econf failed."
	emake || die "emake failed."
}

src_install() {
	einstall
}
