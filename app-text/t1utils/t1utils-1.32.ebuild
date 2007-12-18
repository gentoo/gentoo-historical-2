# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-text/t1utils/t1utils-1.32.ebuild,v 1.10 2007/12/18 19:08:49 jer Exp $

IUSE=""

DESCRIPTION="Type 1 Font utilities"
SRC_URI="http://www.lcdf.org/type/${P}.tar.gz"
HOMEPAGE="http://www.lcdf.org/type/#t1utils"
KEYWORDS="alpha amd64 ~hppa ia64 ppc ~ppc64 sparc x86"
SLOT="0"
LICENSE="BSD"

DEPEND="virtual/libc"

src_install () {
	einstall || die
	dodoc NEWS README
}
