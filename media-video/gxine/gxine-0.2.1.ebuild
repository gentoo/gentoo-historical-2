# Copyright 1999-2003 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-video/gxine/gxine-0.2.1.ebuild,v 1.4 2003/09/07 00:08:13 msterret Exp $

DESCRIPTION="GTK+ Front-End for libxine"
HOMEPAGE="http://xine.sourceforge.net/"
LICENSE="GPL-2"

DEPEND="media-libs/libpng
	>=media-libs/xine-lib-1_alpha2
	X? ( virtual/x11 )
	aalib? ( media-libs/aalib )
	gnome? ( gnome-base/ORBit )
	directfb? ( media-libs/aalib
	>=dev-libs/DirectFB-0.9.9 )"
RDEPEND="nls? ( sys-devel/gettext )"

IUSE="X aalib gnome nls directfb"

SLOT="0"
KEYWORDS="x86"

S=${WORKDIR}/${P}
SRC_URI="mirror://sourceforge/xine/${P}.tar.gz"

src_unpack() {

	unpack ${A}
	cd ${S}

	use directfb || ( \
		sed -e "s:dfb::" src/Makefile.in \
		    > src/Makefile.in.hacked
		mv src/Makefile.in.hacked src/Makefile.in
	)

	sed -e "s:LDFLAGS =:LDFLAGS = -L/lib:" src/xitk/Makefile.in \
	    > src/xitk/Makefile.in.hacked
	mv src/xitk/Makefile.in.hacked src/xitk/Makefile.in

}

src_compile() {

	# Most of these are not working currently, but are here for completeness
	local myconf
	use X	   || myconf="${myconf} --disable-x11 --disable-xv"
	use nls	   || myconf="${myconf} --disable-nls"

	econf ${myconf} || die
	emake || die
}

src_install() {

	make DESTDIR=${D} \
		docdir=/usr/share/doc/${PF} \
		docsdir=/usr/share/doc/${PF} \
		install || die

	dodoc AUTHORS COPYING ChangeLog INSTALL NEWS README
}
