# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-video/gxine/gxine-0.5.906.ebuild,v 1.1 2011/10/04 13:10:48 ssuominen Exp $

EAPI=4
inherit autotools eutils fdo-mime gnome2-utils multilib nsplugins toolchain-funcs

DESCRIPTION="GTK+ Front-End for libxine"
HOMEPAGE="http://xine.sourceforge.net/"
SRC_URI="mirror://sourceforge/xine/${P}.tar.xz"

LICENSE="GPL-2"
SLOT="0"
# Temporarily unkeyworded for testing -ssuominen
#KEYWORDS="~amd64 ~ppc ~ppc64 ~x86"
IUSE="gnome lirc nls nsplugin udev xcb xinerama"

RDEPEND=">=media-libs/xine-lib-1.1.17
	>=x11-libs/gtk+-2.8:2
	>=dev-libs/glib-2.10:2
	>=x11-libs/pango-1.12
	>=dev-lang/spidermonkey-1.8.2.15
	x11-libs/libX11
	x11-libs/libXext
	x11-libs/libXrender
	gnome? ( >=dev-libs/dbus-glib-0.88 )
	lirc? ( app-misc/lirc )
	nls? ( virtual/libintl )
	nsplugin? ( dev-libs/nspr
		x11-libs/libXaw
		x11-libs/libXt )
	udev? ( || ( >=sys-fs/udev-171-r1[gudev] <sys-fs/udev-171-r1[extras] ) )
	xcb? ( x11-libs/libxcb )
	xinerama? ( x11-libs/libXinerama )"
DEPEND="${RDEPEND}
	dev-util/pkgconfig
	nls? ( sys-devel/gettext )"

src_prepare() {
	# ld: cannot find -ljs
	sed -i -e '/JS_LIBS="`spidermonkey_locate_lib/s:js:mozjs:' m4/_js.m4 || die

	epatch \
		"${FILESDIR}"/${PN}-0.5.905-desktop.patch \
		"${FILESDIR}"/${PN}-0.5.905-fix-nspr-useage.patch \
		"${FILESDIR}"/${P}-endif.patch

	# need to disable calling of xine-list when running without
	# userpriv, otherwise we get sandbox violations (bug #233847)
	if [[ ${EUID} == "0" ]]; then
		sed -i -e 's:^XINE_LIST=.*$:XINE_LIST=:' configure.ac || die
	fi

	eautoreconf
}

src_configure() {
	econf \
		$(use_enable nls) \
		$(use_enable lirc) \
		--enable-watchdog \
		$(use_with xcb) \
		$(has_version '<dev-lang/spidermonkey-1.8.5' && echo --with-spidermonkey=/usr/include/js) \
		$(use_with nsplugin browser-plugin) \
		$(use_with udev gudev) \
		--without-hal \
		$(use_with gnome dbus) \
		$(use_with xinerama)
}

src_install() {
	emake DESTDIR="${D}" \
		docdir=/usr/share/doc/${PF} \
		docsdir=/usr/share/doc/${PF} \
		install

	dodoc AUTHORS BUGS ChangeLog NEWS README{,.{cs,de},_l10n} TODO
	use nsplugin && inst_plugin /usr/$(get_libdir)/gxine/gxineplugin.so
}

pkg_preinst() {
	gnome2_icon_savelist
}

pkg_postinst() {
	fdo-mime_desktop_database_update
	fdo-mime_mime_database_update
	gnome2_icon_cache_update
}

pkg_postrm() {
	fdo-mime_desktop_database_update
	fdo-mime_mime_database_update
	gnome2_icon_cache_update
}
