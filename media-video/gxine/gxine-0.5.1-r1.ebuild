# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-video/gxine/gxine-0.5.1-r1.ebuild,v 1.5 2006/01/11 21:27:57 flameeyes Exp $

inherit eutils nsplugins fdo-mime

DESCRIPTION="GTK+ Front-End for libxine"
HOMEPAGE="http://xine.sourceforge.net/"
LICENSE="GPL-2"

RDEPEND="media-libs/libpng
	>=media-libs/xine-lib-1_beta10
	>=x11-libs/gtk+-2.6
	>=dev-libs/glib-2.6
	>=dev-lang/spidermonkey-1.5_rc6-r1
	lirc? ( app-misc/lirc )
	|| ( ( x11-libs/libX11
		x11-libs/libXext
		x11-libs/libXinerama
		x11-libs/libXrender )
		virtual/x11 )"
DEPEND="${RDEPEND}
	nls? ( sys-devel/gettext )
	dev-util/pkgconfig
	|| ( ( x11-base/xorg-server
		x11-libs/libX11
		x11-libs/libXt
		x11-libs/libXaw
		x11-proto/xineramaproto
		x11-proto/xproto
		x11-proto/xextproto )
		virtual/x11 )"

IUSE="nls lirc nsplugin"

SLOT="0"
# Those needs spidermonkey: ~sparc
KEYWORDS="~amd64 ~ppc ~ppc64 ~x86"

SRC_URI="mirror://sourceforge/xine/${P}.tar.bz2"

src_unpack() {
	unpack ${A}
	cd ${S}

	epatch "${FILESDIR}/${P}-pixmap-fixup.patch"
}

src_compile() {
	econf \
		$(use_enable nls) \
		$(use_enable lirc) \
		$(use_with nsplugin browser-plugin) \
		--disable-gtk-compat \
		--disable-dependency-tracking || die
	emake || die
}

src_install() {
	make DESTDIR=${D} \
		docdir=/usr/share/doc/${PF} \
		docsdir=/usr/share/doc/${PF} \
		install || die

	dodoc AUTHORS ChangeLog NEWS README

	use nsplugin && inst_plugin /usr/$(get_libdir)/gxine/gxineplugin.so
}

pkg_postinst() {
	fdo-mime_desktop_database_update
	fdo-mime_mime_database_update
}
