# Copyright 1999-2002 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-editors/nvi/nvi-1.81.4.ebuild,v 1.10 2002/12/09 04:17:40 manson Exp $

DESCRIPTION="Vi clone"
SRC_URI="http://www.kotnet.org/~skimo/nvi/devel/${P}.tar.gz"
HOMEPAGE="http://www.bostic.com/vi/"

SLOT="0"
LICENSE="Sleepycat"
KEYWORDS="x86 ppc sparc "

DEPEND=">=sys-libs/db-3.1"
RDEPEND=""

src_compile() {
	cd build.unix
	../dist/configure \
		--infodir=/usr/share/info \
		--mandir=/usr/share/man \
		--prefix=/usr \
		--host=${CHOST} || die
	emake || die
}

src_install() {
	cd ${S}/build.unix
	einstall
}
