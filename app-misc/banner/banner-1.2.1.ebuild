# Copyright 1999-2004 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-misc/banner/banner-1.2.1.ebuild,v 1.7 2004/06/24 22:02:34 agriffis Exp $

DESCRIPTION="The well known banner program for linux"
HOMEPAGE="http://cedar-solutions.com"
SRC_URI="http://cedar-solutions.com/software/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="x86 ~ppc amd64 ~sparc"
IUSE=""

DEPEND="virtual/glibc"

src_compile() {
	econf || die "econf failed"
	emake || die
}

src_install() {
	einstall
	dodoc README AUTHORS COPYING INSTALL
}
