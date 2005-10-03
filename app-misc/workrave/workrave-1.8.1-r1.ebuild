# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-misc/workrave/workrave-1.8.1-r1.ebuild,v 1.3 2005/10/03 06:59:29 leonardop Exp $

inherit eutils gnome2

DESCRIPTION="Helpful utility to attack Repetitive Strain Injury (RSI)"
HOMEPAGE="http://workrave.sourceforge.net/"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 x86"
IUSE="arts dbus distribution gnome kde nls xml2"

RDEPEND=">=dev-libs/glib-2
	>=gnome-base/gconf-2
	>=x11-libs/gtk+-2
	>=dev-cpp/gtkmm-2.4
	>=dev-cpp/glibmm-2.4
	gnome? (
		>=gnome-base/libgnomeui-2
		>=dev-cpp/libgnomeuimm-2.6
		>=gnome-base/gnome-panel-2.0.10
		>=gnome-base/libbonobo-2
		>=gnome-base/orbit-2.8.3 )
	>=dev-libs/libsigc++-2.0
	distribution? ( >=net-libs/gnet-2 )
	dbus? ( >=sys-apps/dbus-0.22 )
	nls? ( sys-devel/gettext )
	xml2? ( dev-libs/gdome2 )
	kde? (
		=x11-libs/qt-3*
		kde-base/kdelibs )
	arts? ( kde-base/arts )"

DEPEND="${RDEPEND}
	>=dev-util/pkgconfig-0.9"

MAKEOPTS="${MAKEOPTS} -j1"
DOCS="ABOUT-NLS AUTHORS ChangeLog NEWS README"


pkg_setup() {
	G2CONF="--enable-gconf \
		$(use_enable distribution)  \
		$(use_enable nls)           \
		$(use_enable xml2 xml)      \
		$(use_enable gnome)         \
		$(use_enable gnome gnomemm) \
		$(use_enable dbus)          \
		$(use_enable kde)           \
		$(use_with arts)"
}

src_unpack() {
	unpack "${A}"
	cd "${S}"

	# Removes a few broken macros. See bug #86939.
	epatch ${FILESDIR}/${PN}-1.6.2-nls_macros.patch
}

src_compile() {
	if use kde; then
		addwrite "${ROOT}/usr/qt/3/etc/settings"
		export KDEDIR=$(kde-config --prefix)
		einfo "KDEDIR set to ${KDEDIR}"
	fi

	gnome2_src_compile
}
