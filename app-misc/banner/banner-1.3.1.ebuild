# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-misc/banner/banner-1.3.1.ebuild,v 1.11 2007/03/12 14:42:37 armin76 Exp $

DESCRIPTION="The well known banner program for linux"
HOMEPAGE="http://cedar-solutions.com"
SRC_URI="http://cedar-solutions.com/ftp/software/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="alpha ~amd64 mips ppc ppc64 sparc x86 ~x86-fbsd"
IUSE=""

DEPEND="virtual/libc
	!games-misc/bsd-games"

src_install() {
	einstall || die
	dodoc README AUTHORS INSTALL
}
