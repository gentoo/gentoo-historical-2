# Copyright 1999-2003 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/x11-misc/xaos/xaos-3.1_pre5.ebuild,v 1.6 2003/09/05 23:18:18 msterret Exp $

IUSE="X svga aalib"

MY_PN="XaoS"
MY_P=${MY_PN}-${PV/_/}
S=${WORKDIR}/${MY_P}

DESCRIPTION="A very fast real-time fractal zoomer"
HOMEPAGE="http://sourceforge.net/projects/xaos/"
SRC_URI="mirror://sourceforge/xaos/${MY_P}.tar.gz"

SLOT="0"
LICENSE="GPL-2"
KEYWORDS="x86 ~ppc"

DEPEND="X? ( virtual/x11 )
	svga? ( >=media-libs/svgalib-1.4.3 )
	aalib? ( media-libs/aalib )
	sys-libs/zlib
	media-libs/libpng"


src_compile() {
	local myconf
	use X     || myconf="--with-x11-driver=no"
#	use dga   || myconf="${myconf} --with-dga-driver=no"

# ggi support is broken
#	use ggi   ||
	myconf="${myconf} --with-ggi-driver=no"
	use svga  || myconf="${myconf} --with-svga-driver=no"
#	use aalib || myconf="${myconf} --with-aa-driver=no"

	#i18n support is quite broken in XaoS, it gets installed
	#anyway, so we remove it later during install if not desired
	use nls   || myconf="${myconf} --with-i18n=no"

	./configure --prefix=/usr ${myconf} && make || die
}

src_install() {
	# these get installed, assuming that the directories exist!
	mkdir -p ${D}/usr/share/locale/{hu,es,fr,cs,de}/LC_MESSAGES
	mkdir -p ${D}/usr/share/{man,info}
	make \
		prefix=${D}/usr \
		infodir=${D}/usr/share/info \
		mandir=${D}/usr/share/man \
		LOCALEDIR=${D}/usr/share/locale \
	install || die

	use nls || rm -r ${D}/usr/share/locale

	dodoc ChangeLog* COPYING INSTALL* TODO*
}
