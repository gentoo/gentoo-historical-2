# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-arch/gzip-x86/gzip-x86-0.90.ebuild,v 1.6 2005/01/01 11:46:02 eradicator Exp $

MY_P=${PN/-/_}-${PV}
S=${WORKDIR}/${MY_P}
DESCRIPTION="gzip_x86 is an optimized gzip for x86 arch"
HOMEPAGE="ftp://spruce.he.net/pub/jreiser"
SRC_URI="ftp://spruce.he.net/pub/jreiser/${MY_P}.tgz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="-* x86 amd64"
IUSE=""

DEPEND="virtual/libc"
PROVIDE="virtual/gzip"

src_install() {
	make DESTDIR=${D} install || die
}
