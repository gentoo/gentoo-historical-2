# Copyright 1999-2004 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-editors/nvi/nvi-1.81.5-r1.ebuild,v 1.5 2004/03/13 23:00:56 mr_bones_ Exp $

DESCRIPTION="Vi clone"
SRC_URI="http://www.kotnet.org/~skimo/nvi/devel/${P}.tar.gz"
HOMEPAGE="http://www.bostic.com/vi/"
SLOT="0"
LICENSE="Sleepycat"
KEYWORDS="x86 ~ppc ~sparc hppa alpha ~mips"
DEPEND="virtual/glibc
		=sys-libs/db-3.2*"
PROVIDE="virtual/editor"
IUSE=""

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
	einstall
}
