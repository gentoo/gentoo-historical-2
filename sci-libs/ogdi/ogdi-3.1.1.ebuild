# Copyright 1999-2004 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sci-libs/ogdi/ogdi-3.1.1.ebuild,v 1.1 2004/12/28 22:57:03 ribosome Exp $

DESCRIPTION="open geographical datastore interface"
HOMEPAGE="http://ogdi.sourceforge.net"
SRC_URI="mirror://sourceforge/ogdi/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="x86 ~sparc ~hppa ~alpha ~amd64 ~ppc ~ppc64"
IUSE=""

DEPEND="dev-libs/proj
	sys-libs/zlib
	dev-libs/expat"

src_compile() {
	export TOPDIR="${S}"
	export TARGET="linux"
	export CFG="release"
	export LD_LIBRARY_PATH="${TOPDIR}/bin/${TARGET}"

	./configure \
		--host=${CHOST} \
		--prefix=/usr \
		--infodir=/usr/share/info \
		--mandir=/usr/share/man \
		--with-proj \
		--with-projlib=/usr/lib \
		--with-projinc=/usr/include \
		--with-zlib \
		--with-zliblib=/usr/lib \
		--with-zlibinc=/usr/include \
		--with-expat \
		--with-expatlib=/usr/lib \
		--with-expatinc=/usr/include || die "./configure failed"
	make || die "make failed"
}

src_install() {
	make \
		prefix=${D}usr \
		mandir=${D}usr/share/man \
		infodir=${D}usr/share/info \
		TOPDIR="${S}" TARGET="linux" LD_LIBRARY_PATH="${TOPDIR}/bin/${TARGET}" \
		install || die "make install failed"

	dodoc ChangeLog LICENSE NEWS README VERSION
}
