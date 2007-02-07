# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-util/ltrace/ltrace-0.3.36.ebuild,v 1.7 2007/02/07 00:35:46 jer Exp $

inherit eutils

MY_P="${P/-/_}"
DEB_P="${MY_P}-2"

DESCRIPTION="trace library calls made at runtime"
HOMEPAGE="http://packages.debian.org/unstable/utils/ltrace.html"
SRC_URI="mirror://debian/pool/main/l/ltrace/${MY_P}.orig.tar.gz
	mirror://debian/pool/main/l/ltrace/${DEB_P}.diff.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="alpha ~amd64 ~ia64 ~mips ppc -sparc x86"
IUSE=""

DEPEND="virtual/libc
	dev-libs/elfutils"

src_unpack() {
	unpack ${A}
	epatch "${WORKDIR}"/${DEB_P}.diff
}

src_install() {
	make DESTDIR="${D}" install || die "make install failed"

	rm -rf "${D}"/usr/doc/
	dodoc BUGS debian/changelog README TODO
}
