# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-misc/remmina/remmina-9999.ebuild,v 1.7 2012/02/15 00:52:55 floppym Exp $

EAPI="4"
EGIT_REPO_URI="git://github.com/FreeRDP/Remmina.git"

inherit gnome2-utils cmake-utils git-2

DESCRIPTION="A GTK+ RDP, VNC, XDMCP and SSH client"
HOMEPAGE="http://remmina.sourceforge.net/"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS=""
IUSE="ayatana avahi crypt debug freerdp nls ssh telepathy unique vte"

RDEPEND="x11-libs/gtk+:2
	net-libs/libvncserver
	x11-libs/libxkbfile
	gnome-base/libgnome-keyring
	ayatana? ( dev-libs/libappindicator )
	avahi? ( net-dns/avahi )
	crypt? ( dev-libs/libgcrypt )
	freerdp? ( >=net-misc/freerdp-1.0 )
	ssh? ( net-libs/libssh[sftp] )
	telepathy? ( net-libs/telepathy-glib )
	!net-misc/remmina-plugins
	vte? ( x11-libs/vte )"
DEPEND="${RDEPEND}
	dev-util/intltool
	dev-util/pkgconfig
	nls? ( sys-devel/gettext )"

DOCS=( README )

src_prepare() {
	sed -i -e "/REMMINA_PLUGINDIR/s:lib:$(get_libdir):" CMakeLists.txt || die
}

src_configure() {
	local mycmakeargs=(
		$(cmake-utils_use_with ayatana APPINDICATOR)
		$(cmake-utils_use_with avahi AVAHI)
		$(cmake-utils_use_with crypt GCRYPT)
		$(cmake-utils_use_with freerdp FREERDP)
		$(cmake-utils_use_with ssh LIBSSH)
		$(cmake-utils_use_with telepathy TELEPATHY)
		$(cmake-utils_use_with vte VTE)
		-DHAVE_PTHREAD=ON
	)
	cmake-utils_src_configure
}

pkg_preinst() {
	gnome2_icon_savelist
}

pkg_postinst() {
	elog "You need to install net-misc/remmina-plugins which"
	elog "provide all the necessary network protocols required by ${PN}"
	gnome2_icon_cache_update
}

pkg_postrm() {
	gnome2_icon_cache_update
}
