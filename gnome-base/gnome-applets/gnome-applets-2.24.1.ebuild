# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/gnome-base/gnome-applets/gnome-applets-2.24.1.ebuild,v 1.1 2008/11/08 23:29:33 eva Exp $

inherit gnome2 python

DESCRIPTION="Applets for the GNOME Desktop and Panel"
HOMEPAGE="http://www.gnome.org/"

LICENSE="GPL-2 FDL-1.1 LGPL-2"
SLOT="2"
KEYWORDS="~alpha ~amd64 ~hppa ~ia64 ~ppc64 ~sparc ~x86"
IUSE="acpi apm doc gnome gstreamer hal ipv6"

# TODO: configure says python stuff is optional
# my secret script says cpufrequtils might be needed in RDEPEND

RDEPEND=">=x11-libs/gtk+-2.13
		>=dev-libs/glib-2.18.0
		>=gnome-base/libgnome-2.8
		>=gnome-base/libgnomeui-2.8
		>=gnome-base/gconf-2.8
		>=gnome-base/gnome-panel-2.13.4
		>=x11-libs/libxklavier-2.91
		>=x11-libs/libwnck-2.9.3
		>=gnome-base/gnome-desktop-2.11.1
		>=x11-libs/libnotify-0.3.2
		hal? ( >=sys-apps/hal-0.5.3 )
		>=sys-apps/dbus-1.1.2
		>=dev-libs/dbus-glib-0.74
		>=dev-libs/libxml2-2.5.0
		>=x11-themes/gnome-icon-theme-2.15.91
		>=dev-libs/libgweather-2.22.1
		>=virtual/python-2.4
		apm? ( sys-apps/apmd )
		x11-libs/libX11
		gnome?	(
			>=gnome-base/libgnomekbd-2.21.4.1
			gnome-base/gnome-settings-daemon

			>=gnome-extra/gucharmap-1.4
			>=gnome-base/libgtop-2.11.92

			>=dev-python/pygtk-2.6
			>=dev-python/gnome-python-2.10 )
		gstreamer?	(
			>=media-libs/gstreamer-0.10.2
			>=media-libs/gst-plugins-base-0.10.14 )"

DEPEND="${RDEPEND}
		>=app-text/scrollkeeper-0.1.4
		>=app-text/gnome-doc-utils-0.3.2
		>=dev-util/pkgconfig-0.19
		>=dev-util/intltool-0.35
		dev-libs/libxslt
		~app-text/docbook-xml-dtd-4.3
		doc? (
				app-text/docbook-sgml-utils
			)"

DOCS="AUTHORS ChangeLog NEWS README"

src_unpack() {
	gnome2_src_unpack

	# disable pyc compiling
	mv py-compile py-compile.orig
	ln -s $(type -P true) py-compile
}

pkg_setup() {
	G2CONF="${G2CONF}
		--disable-scrollkeeper
		--disable-schemas-install
		--enable-flags
		$(use_with hal)
		$(use_enable ipv6)
		--disable-polkit"

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

src_install() {
	gnome2_src_install

	local APPLETS="accessx-status battstat charpick cpufreq drivemount geyes \
			 gkb-new gswitchit gweather invest-applet mini-commander \
			 mixer modemlights multiload null_applet stickynotes trashapplet"

	# modemlights is out because it needs system-tools-backends-1

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

	# check for new python modules on bumps
	python_version
	python_mod_optimize /usr/$(get_libdir)/python${PYVER}/site-packages/invest
}

pkg_postrm() {
	gnome2_pkg_postrm
	python_mod_cleanup /usr/$(get_libdir)/python*/site-packages/invest
}
