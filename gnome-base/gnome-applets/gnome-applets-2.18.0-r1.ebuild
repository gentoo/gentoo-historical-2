# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/gnome-base/gnome-applets/gnome-applets-2.18.0-r1.ebuild,v 1.1 2007/05/02 04:46:04 compnerd Exp $

inherit eutils gnome2 autotools

DESCRIPTION="Applets for the GNOME Desktop and Panel"
HOMEPAGE="http://www.gnome.org/"

LICENSE="GPL-2 FDL-1.1 LGPL-2"
SLOT="2"
KEYWORDS="~alpha ~amd64 ~hppa ~ia64 ~ppc ~ppc64 ~sparc ~x86 ~x86-fbsd"
IUSE="acpi apm doc gnome gstreamer hal ipv6"

RDEPEND=">=x11-libs/gtk+-2.6
		>=dev-libs/glib-2.6
		>=gnome-base/libgnome-2.8
		>=gnome-base/libgnomeui-2.8
		>=gnome-base/gconf-2.8
		>=gnome-base/gnome-panel-2.13.4
		>=gnome-base/libglade-2.4
		>=gnome-base/gail-1.1
		>=x11-libs/libxklavier-2.91
		>=x11-libs/libwnck-2.9.3
		>=app-admin/system-tools-backends-1.1.3
		>=gnome-base/gnome-desktop-2.11.1
		>=x11-libs/libnotify-0.3.2
		hal? ( >=sys-apps/hal-0.5.3 )
		||  (
				>=dev-libs/dbus-glib-0.71
				( <sys-apps/dbus-0.90 >=sys-apps/dbus-0.34 )
			)
		>=x11-themes/gnome-icon-theme-2.15.91
		>=dev-libs/libxml2-2.5.0
		>=virtual/python-2.4
		apm? ( sys-apps/apmd )
		x11-apps/xrdb x11-libs/libX11
		gnome?	(
					gnome-base/libgnomekbd
					gnome-base/control-center

					>=gnome-extra/gucharmap-1.4
					>=gnome-base/libgtop-2.11.92
					>=gnome-base/gnome-vfs-2.15.4

					>=dev-python/pygtk-2.6
					>=dev-python/gnome-python-2.10
				)
		gstreamer?	(
						>=media-libs/gstreamer-0.10.2
						>=media-libs/gst-plugins-base-0.10.2
					)"

DEPEND="${RDEPEND}
		>=app-text/scrollkeeper-0.1.4
		>=dev-util/pkgconfig-0.19
		>=dev-util/intltool-0.35
		dev-libs/libxslt
		doc? (
				app-text/docbook-sgml-utils
				>=app-text/gnome-doc-utils-0.3.2
				~app-text/docbook-xml-dtd-4.3
			)"

DOCS="AUTHORS ChangeLog NEWS README"

MAKEOPTS="${MAKEOPTS} -j1"

pkg_setup() {
	G2CONF="--disable-scrollkeeper --enable-flags \
		$(use_with hal)
		$(use_enable ipv6)
		$(use_enable doc gtk-doc)"

	if use gstreamer; then
		G2CONF="${G2CONF} --with-gstreamer=0.10"
	fi

	if ! use ppc && ! use apm && ! use acpi; then
		G2CONF="${G2CONF} --disable-battstat"
	fi

	if use ppc && ! use apm; then
		G2CONF="${G2CONF} --disable-battstat"
	fi
}

src_unpack() {
	gnome2_src_unpack
	epatch ${FILESDIR}/${PN}-2.18.0-deprecated-acpi-info.patch
}

src_install() {
	gnome2_src_install

	APPLETS="accessx-status battstat charpick cpufreq drivemount geyes \
			 gkb-new gswitchit gweather invest-applet mini-commander \
			 mixer modemlights multiload null_applet stickynotes trashapplet"

	for applet in ${APPLETS} ; do
		docinto ${applet}

		for d in AUTHORS ChangeLog NEWS README README.themes TODO ; do
			[ -s ${applet}/${d} ] && dodoc ${applet}/${d}
		done
	done
}

pkg_postinst() {
	gnome2_pkg_postinst

	if use acpi && ! use hal ; then
		elog "It is highly recommended that you install acpid if you use the"
		elog "battstat applet to prevent any issues with other applications "
		elog "trying to read acpi information."
	fi
}
