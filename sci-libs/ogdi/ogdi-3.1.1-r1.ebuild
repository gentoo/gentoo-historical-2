# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sci-libs/ogdi/ogdi-3.1.1-r1.ebuild,v 1.1 2005/07/23 02:20:14 nerdboy Exp $

DESCRIPTION="open geographical datastore interface"
HOMEPAGE="http://ogdi.sourceforge.net"
SRC_URI="mirror://sourceforge/ogdi/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~hppa ppc ~ppc64 sparc x86"
IUSE=""

DEPEND="sci-libs/proj
	sys-libs/zlib
	dev-libs/expat"

src_compile() {
	export TOPDIR="${S}"
	export TARGET=`uname`
	export CFG="release"
	export LD_LIBRARY_PATH=$TOPDIR/bin/${TARGET}

	econf --with-proj=/usr --with-projlib="-L/usr/lib -lproj" \
	    --with-zlib --with-expat || die "econf failed"
	make || die "make failed"
}

src_install() {
	einstall TARGET=`uname` TOPDIR="${S}" \
		 LD_LIBRARY_PATH="${TOPDIR}/bin/${TARGET}" || die "einstall failed"
	dodoc ChangeLog LICENSE NEWS README VERSION
}
