# Copyright 1999-2004 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-text/t1utils/t1utils-1.28.ebuild,v 1.5 2004/05/18 20:07:10 kugelfang Exp $

IUSE=""

DESCRIPTION="Type 1 Font utilities"
SRC_URI="http://www.lcdf.org/type/${P}.tar.gz"
HOMEPAGE="http://www.lcdf.org/type/#t1utils"
KEYWORDS="~x86 ~sparc alpha ~ppc ia64 ~amd64"
SLOT="0"
LICENSE="BSD"

DEPEND="virtual/glibc"

src_install () {
	einstall || die
	dodoc NEWS README
}
