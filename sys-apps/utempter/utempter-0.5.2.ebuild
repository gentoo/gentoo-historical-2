# Copyright 1999-2003 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sys-apps/utempter/utempter-0.5.2.ebuild,v 1.5 2003/04/05 22:31:21 danarmak Exp $

S=${WORKDIR}/${P}
DESCRIPTION="App that allows non-privileged apps to write utmp (login) info, which needs root access"
# no homepage really, but redhat are the authors
HOMEPAGE="http://www.redhat.com"
SRC_URI="mirror://gentoo/${P}.tar.gz"

SLOT="0"
LICENSE="GPL-2"
KEYWORDS="x86"

RDEPEND="virtual/glibc"


src_compile() {
	export RPM_OPT_FLAGS="$CFLAGS"
	make || die
}

src_install() {
	make RPM_BUILD_ROOT="$D" install
	dobin utmp
	dodoc COPYING
}
