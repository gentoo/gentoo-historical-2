# Copyright 1999-2004 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sys-libs/rvm/rvm-1.9.ebuild,v 1.2 2004/06/24 23:09:31 agriffis Exp $

DESCRIPTION="Recoverable Virtual Memory (used by Coda)"
HOMEPAGE="http://www.coda.cs.cmu.edu/"
SRC_URI="ftp://ftp.coda.cs.cmu.edu/pub/rvm/src/${P}.tar.gz"
IUSE=""
SLOT="1"
LICENSE="LGPL-2.1"
KEYWORDS="~x86 ~ppc ~sparc ~alpha ~hppa ~mips ~amd64 ~ia64"

DEPEND="virtual/glibc
	>=sys-libs/lwp-1.10
	sys-apps/grep
	sys-devel/libtool
	sys-devel/gcc"

RDEPEND="virtual/glibc
	>=sys-libs/lwp-1.10"


src_install() {
	make DESTDIR=${D} install || die

	dodoc AUTHORS ChangeLog NEWS
}
