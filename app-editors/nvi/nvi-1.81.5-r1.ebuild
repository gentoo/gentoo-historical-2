# Copyright 1999-2004 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-editors/nvi/nvi-1.81.5-r1.ebuild,v 1.8 2004/06/27 22:17:46 vapier Exp $

DESCRIPTION="Vi clone"
HOMEPAGE="http://www.bostic.com/vi/"
SRC_URI="http://www.kotnet.org/~skimo/nvi/devel/${P}.tar.gz"

LICENSE="Sleepycat"
SLOT="0"
KEYWORDS="x86 ~ppc ~sparc ~mips alpha hppa"
IUSE=""

DEPEND="virtual/libc
	=sys-libs/db-3.2*"
PROVIDE="virtual/editor"

src_unpack() {
	unpack ${P}.tar.gz
	sed -e 's|-ldb|-ldb-3.2|g' -e 's|libdb-3|libdb-3.2|g' -i ${S}/dist/configure
}

src_compile() {
	local myconf=""
	export LIBS="-lpthread"
	export ADDCPPFLAGS="-I/usr/include/db3"
	cd build.unix
	../dist/configure \
		--infodir=/usr/share/info \
		--mandir=/usr/share/man \
		--prefix=/usr \
		--host=${CHOST} \
		${myconf} || die "configure failed"
	einfo "Doing make now"
	emake || die "emake failed"
}

src_install() {
	cd ${S}/build.unix
	einstall || die
}
