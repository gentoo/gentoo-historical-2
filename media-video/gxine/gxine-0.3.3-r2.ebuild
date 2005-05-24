# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-video/gxine/gxine-0.3.3-r2.ebuild,v 1.1 2005/05/24 14:01:03 flameeyes Exp $

inherit eutils nsplugins

DESCRIPTION="GTK+ Front-End for libxine"
HOMEPAGE="http://xine.sourceforge.net/"
LICENSE="GPL-2"

DEPEND="media-libs/libpng
	>=media-libs/xine-lib-1_beta10
	>=x11-libs/gtk+-2.0.0
	lirc? ( app-misc/lirc )
	X? ( virtual/x11 )"
RDEPEND="nls? ( sys-devel/gettext )"

IUSE="X nls lirc"

SLOT="0"
KEYWORDS="~amd64 ~ppc ~ppc64 ~sparc ~x86"

SRC_URI="mirror://sourceforge/xine/${P}.tar.gz"

src_unpack() {
	unpack ${A}

	cd ${S}

	#fixes bug #65303 with missing X11 libs
	epatch ${FILESDIR}/${P}-Makefile.in.patch

	#fixes bug http overflow security bug #70055
	epatch ${FILESDIR}/${P}-http-overflow.patch

	#fixes format string security bug #93532
	epatch ${FILESDIR}/${P}-secfix.patch
}

src_compile() {

	# Most of these are not working currently, but are here for completeness
	local myconf
	use X	   || myconf="${myconf} --disable-x11 --disable-xv"

	myconf="${myconf} $(use_enable nls)"

	econf ${myconf} || die
	emake || die
}

src_install() {

	make DESTDIR=${D} \
		docdir=/usr/share/doc/${PF} \
		docsdir=/usr/share/doc/${PF} \
		install || die

	insinto /usr/share/pixmaps
	doins pixmaps/gxine-logo.png

	dodoc AUTHORS ChangeLog INSTALL NEWS README

	inst_plugin /usr/$(get_libdir)/gxine/gxineplugin.so
}
