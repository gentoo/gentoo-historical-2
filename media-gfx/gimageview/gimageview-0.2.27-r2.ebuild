# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-gfx/gimageview/gimageview-0.2.27-r2.ebuild,v 1.4 2006/11/04 18:40:58 usata Exp $

inherit eutils

DESCRIPTION="Powerful GTK+ based image & movie viewer"
HOMEPAGE="http://gtkmmviewer.sourceforge.net/"
SRC_URI="mirror://sourceforge/gtkmmviewer/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ~hppa ppc ppc64 x86"
# mng, xine, and mplayer are local flags
IUSE="nls imlib wmf mng svg xine mplayer"

RDEPEND=">=x11-libs/gtk+-2
	media-libs/libpng
	wmf? ( >=media-libs/libwmf-0.2.8 )
	mng? ( >=media-libs/libmng-1.0.3 )
	svg? ( >=gnome-base/librsvg-1.0.3 )
	xine? ( >=media-libs/xine-lib-0.9.13-r3 )
	mplayer? ( >=media-video/mplayer-0.92 )
	imlib? ( media-libs/imlib )"
DEPEND="${RDEPEND}
	nls? ( sys-devel/gettext )
	dev-util/pkgconfig"

src_unpack() {
	unpack ${A}
	cd ${S}
	epatch ${FILESDIR}/${P}-sort_fix.diff
	epatch ${FILESDIR}/${P}-gtk12_fix.diff
}

src_compile() {
	econf \
		$(use_enable nls) \
		$(use_with wmf libwmf) \
		$(use_with mng libmng) \
		$(use_with svg librsvg) \
		$(use_with xine) \
		$(use_enable mplayer) \
		--with-gtk2 \
		--enable-splash || die

	emake || die
}

src_install() {
	# make DESTDIR=${D} install doesn't work
	einstall desktopdir=${D}/usr/share/applications || die
}

pkg_postinst() {
	einfo ""
	einfo "If you want to open archived files, you have to emerge"
	einfo "'app-arch/rar' and/or 'app-arch/lha'."
	einfo "e.g.) # emerge app-arch/rar"
	einfo ""
}
