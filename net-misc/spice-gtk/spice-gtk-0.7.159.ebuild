# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-misc/spice-gtk/spice-gtk-0.7.159.ebuild,v 1.1 2012/01/07 20:38:03 nirbheek Exp $

EAPI="4"
GCONF_DEBUG="no"

inherit eutils python gnome2-utils

PYTHON_DEPEND="python? 2"

DESCRIPTION="Set of GObject and Gtk objects for connecting to Spice servers and a client GUI."
HOMEPAGE="http://spice-space.org http://gitorious.org/spice-gtk"

LICENSE="LGPL-2.1"
SLOT="0"
SRC_URI="http://spice-space.org/download/gtk/${P}.tar.bz2"
KEYWORDS="~amd64 ~x86"
IUSE="+cairo doc gnome gstreamer gtk3 +introspection kde +pulseaudio python sasl static-libs vala"

RDEPEND="pulseaudio? ( !gstreamer? ( media-sound/pulseaudio ) )
	gstreamer? (
		media-libs/gstreamer:0.10
		media-libs/gst-plugins-base:0.10 )
	>=app-emulation/spice-protocol-0.9.1
	>=x11-libs/pixman-0.17.7
	>=media-libs/celt-0.5.1.1:0.5.1
	dev-libs/openssl
	gtk3? ( x11-libs/gtk+:3[introspection?] )
	!gtk3? ( x11-libs/gtk+:2[introspection?] )
	>=dev-libs/glib-2.26:2
	>=x11-libs/cairo-1.2
	virtual/jpeg
	sys-libs/zlib
	introspection? ( dev-libs/gobject-introspection )
	python? ( dev-python/pygtk:2 )
	sasl? ( dev-libs/cyrus-sasl )
	gnome? ( gnome-base/gconf )"
DEPEND="${RDEPEND}
	vala? ( dev-lang/vala:0.14 )
	dev-lang/python
	dev-lang/perl
	dev-perl/Text-CSV
	dev-python/pyparsing
	dev-util/pkgconfig"

pkg_setup() {
	if use gstreamer && use pulseaudio ; then
		ewarn "spice-gtk can use only one audio backend: gstreamer will be used since you enabled both."
	fi
}

src_configure() {
	local audio="no"
	local gtk="2.0"

	use pulseaudio && audio="pulse"
	use gstreamer && audio="gstreamer"
	# TODO: do a double build like gtk-vnc does to install both gtk2 & gtk3 libs
	use gtk3 && gtk="3.0"
	if use vala ; then
		rm -vf gtk/controller/controller.{c,vala.stamp} gtk/controller/menu.c # force vala regen
	fi

	# TODO: usbredirection support
	#       needs libusbredirhost, newer libusb, policykit, libacl
	econf \
		VALAC=$(type -P valac-0.14) \
		VAPIGEN=$(type -P vapigen-0.14) \
		$(use_enable static-libs static) \
		$(use_enable introspection) \
		--with-audio="${audio}" \
		$(use_with !cairo x11) \
		$(use_with python) \
		$(use_with sasl) \
		$(use_enable vala) \
		--with-gtk="${gtk}" \
		--disable-smartcard \
		--disable-usbredir \
		--disable-werror
}

src_install() {
	emake -j1 DESTDIR="${D}" install || die "emake install failed"

	use static-libs || rm -rf "${D}"/usr/lib*/*.la
	use python && rm -rf "${D}"/usr/lib*/python*/site-packages/*.la
	use doc || rm -rf "${D}/usr/share/gtk-doc"

	dodoc AUTHORS NEWS README TODO

	make_desktop_entry spicy Spicy "" net

	if use gnome ; then
		insinto /etc/gconf/schemas
		doins "${FILESDIR}/spice.schemas"
	fi
	if use kde ; then
		insinto /usr/share/kde4/services
		doins "${FILESDIR}/spice.protocol"
	fi

}

pkg_preinst() {
	use gnome && gnome2_gconf_savelist
}

pkg_postinst() {
	use gnome && gnome2_gconf_install
}

pkg_prerm() {
	use gnome && gnome2_gconf_uninstall
}
