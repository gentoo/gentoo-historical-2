# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/gnome-base/gnome-applets/gnome-applets-2.26.3.ebuild,v 1.7 2009/12/03 17:25:11 ranger Exp $

inherit autotools eutils gnome2 python

DESCRIPTION="Applets for the GNOME Desktop and Panel"
HOMEPAGE="http://www.gnome.org/"

LICENSE="GPL-2 FDL-1.1 LGPL-2"
SLOT="2"
KEYWORDS="alpha amd64 ~hppa ia64 ppc ppc64 sparc x86 ~x86-fbsd"
IUSE="acpi apm doc gnome gstreamer hal ipv6 policykit"

# TODO: configure says python stuff is optional
# my secret script says cpufrequtils might be needed in RDEPEND

RDEPEND=">=x11-libs/gtk+-2.13
	>=dev-libs/glib-2.18.0
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

		>=gnome-extra/gucharmap-2.23
		>=gnome-base/libgtop-2.11.92

		>=dev-python/pygobject-2.6
		>=dev-python/pygtk-2.6
		>=dev-python/libgnome-python-2.10
		>=dev-python/gconf-python-2.10
		>=dev-python/gnome-applets-python-2.10 )
	gstreamer?	(
		>=media-libs/gstreamer-0.10.2
		>=media-libs/gst-plugins-base-0.10.14
		|| (
			>=media-plugins/gst-plugins-alsa-0.10.14
			>=media-plugins/gst-plugins-oss-0.10.14 ) )
	policykit? (
		>=sys-auth/policykit-0.7
		>=gnome-extra/policykit-gnome-0.7 )"

DEPEND="${RDEPEND}
	>=app-text/scrollkeeper-0.1.4
	>=app-text/gnome-doc-utils-0.3.2
	>=dev-util/pkgconfig-0.19
	>=dev-util/intltool-0.35
	dev-libs/libxslt
	~app-text/docbook-xml-dtd-4.3
	doc? ( app-text/docbook-sgml-utils )"

DOCS="AUTHORS ChangeLog NEWS README"

src_unpack() {
	gnome2_src_unpack

	# disable pyc compiling
	mv py-compile py-compile.orig
	ln -s $(type -P true) py-compile

	# Networmanager is automagic, bug #266056
	epatch "${FILESDIR}/${PN}-2.26.1-automagic-networkmanager.patch"

	# Make it libtool-1 compatible, bug #266248
	rm -v m4/lt* m4/libtool.m4 || die "removing libtool macros failed"

	# Invest applet tests need gconf/proxy/...
	sed 's/^TESTS.*/TESTS=/g' -i invest-applet/invest/Makefile.am \
		invest-applet/invest/Makefile.in || die "disabling invest tests failed"

	# Fix documentation validation, upstream bug #589058
	epatch "${FILESDIR}/${P}-documentation-fix.patch"

	intltoolize --force --copy --automake || die "intltoolize failed"
	eautoreconf
}

pkg_setup() {
	# networkmanager-0.7 is not going stable.
	# For networkmanager support, see -r1
	G2CONF="${G2CONF}
		--disable-scrollkeeper
		--disable-schemas-install
		--enable-flags
		--disable-networkmanager
		$(use_enable gstreamer mixer-applet)
		$(use_with hal)
		$(use_enable ipv6)
		$(use_enable policykit polkit)"

	if ! use ppc && ! use apm && ! use acpi; then
		G2CONF="${G2CONF} --disable-battstat"
	fi

	if use ppc && ! use apm; then
		G2CONF="${G2CONF} --disable-battstat"
	fi
}

src_test() {
	unset DBUS_SESSION_BUS_ADDRESS
	emake check || die "emake check failed"
}

src_install() {
	gnome2_src_install

	local APPLETS="accessx-status battstat charpick cpufreq drivemount geyes
			 gkb-new gswitchit gweather invest-applet mini-commander
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
	python_mod_optimize $(python_get_sitedir)/invest
}

pkg_postrm() {
	gnome2_pkg_postrm
	python_mod_cleanup /usr/$(get_libdir)/python*/site-packages/invest
}
