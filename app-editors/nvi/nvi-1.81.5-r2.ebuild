# Copyright 1999-2004 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-editors/nvi/nvi-1.81.5-r2.ebuild,v 1.3 2004/01/19 01:09:39 ciaranm Exp $

DESCRIPTION="Vi clone"
SRC_URI="http://www.kotnet.org/~skimo/nvi/devel/${P}.tar.gz"
HOMEPAGE="http://www.bostic.com/vi/"
SLOT="0"
LICENSE="Sleepycat"
KEYWORDS="x86 ~ppc sparc hppa alpha ~mips amd64"
DEPEND="virtual/glibc
		=sys-libs/db-3.2*"
PROVIDE="virtual/editor"
IUSE=""

src_unpack() {
	unpack ${A}
	cd ${S}
	sed -i -e 's|-ldb|-ldb-3.2|g' -e 's|libdb-3|libdb-3.2|g' dist/configure \
		|| die "sed failed"
	# Fix bug 23888
	epatch ${FILESDIR}/${P}-tcsetattr.patch || die "epatch failed"
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
