# Copyright 1999-2004 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/x11-misc/xfontselector/xfontselector-0.9.2.ebuild,v 1.12 2004/06/14 18:32:44 pyrania Exp $

MY_P="xfontselector-0.9-2"
S=${WORKDIR}/${MY_P}
DESCRIPTION="This is a font selector for X, much nicer than xfontsel."
SRC_URI="mirror://sourceforge/xfontselector/${MY_P}.tar.gz"
HOMEPAGE="http://xfontselector.sourceforge.net/"
KEYWORDS="x86 sparc ppc ~amd64"
IUSE=""
SLOT="0"
LICENSE="GPL-2"
DEPEND="=x11-libs/qt-2*
	virtual/x11
	media-libs/jpeg
	media-libs/lcms
	media-libs/libmng
	media-libs/libpng
	sys-devel/gcc
	sys-libs/glibc
	sys-libs/zlib"

src_compile() {
	patch Makefile ${FILESDIR}/xfontselector-gentoo.diff || die
	emake || die
}

src_install () {
	dobin xfontselector || die
	doman ${FILESDIR}/xfontselector.1
}
