# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sys-apps/freebsd-stat/freebsd-stat-5.3_p20050202.ebuild,v 1.1 2005/02/02 23:42:13 kito Exp $

DESCRIPTION="FreeBSD stat, readlink - display file status"
HOMEPAGE="http://www.freebsd.org/"
SRC_URI="mirror://gentoo/${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~ppc-macos"
IUSE=""

DEPEND="virtual/libc"

src_compile() {

	gcc -v -o stat stat.c ${CFLAGS} || die "compilation of stat failed"

}

src_install() {
	dobin stat
	doman stat.1
}
