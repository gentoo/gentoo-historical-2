# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-im/gajim/gajim-0.14.4-r1.ebuild,v 1.8 2012/03/18 08:58:56 jlec Exp $

EAPI=4

PYTHON_DEPEND="2"
PYTHON_USE_WITH="sqlite xml"

inherit eutils python versionator

DESCRIPTION="Jabber client written in PyGTK"
HOMEPAGE="http://www.gajim.org/"
SRC_URI="http://www.gajim.org/downloads/$(get_version_component_range 1-2)/${P}.tar.bz2"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="alpha amd64 hppa ia64 ~ppc ~ppc64 sparc x86 ~x86-fbsd"
IUSE="avahi crypt dbus gmail gnome idle jingle libnotify networkmanager nls spell srv X xhtml"

REQUIRED_USE="
	libnotify? ( dbus )
	avahi? ( dbus )"

COMMON_DEPEND="
	dev-python/pygtk:2
	x11-libs/gtk+:2"
DEPEND="${COMMON_DEPEND}
	>=dev-util/intltool-0.40.1
	dev-util/pkgconfig
	>=sys-devel/gettext-0.17-r1"
RDEPEND="${COMMON_DEPEND}
	dev-python/pyopenssl
	crypt? (
		app-crypt/gnupg
		dev-python/pycrypto
		)
	dbus? (
		dev-python/dbus-python
		dev-libs/dbus-glib
		libnotify? ( dev-python/notify-python )
		avahi? ( net-dns/avahi[dbus,gtk,python] )
		)
	gmail? ( net-dns/bind-tools )
	gnome? (
		dev-python/libgnome-python
		dev-python/gnome-keyring-python
		dev-python/egg-python
		)
	idle? ( x11-libs/libXScrnSaver )
	jingle? ( net-libs/farsight2[python] )
	networkmanager? (
			dev-python/dbus-python
			net-misc/networkmanager
		)
	srv? (
		|| (
			dev-python/libasyncns-python
			net-dns/bind-tools )
		)
	spell? ( app-text/gtkspell:2 )
	xhtml? ( dev-python/docutils )"

pkg_setup() {
	python_set_active_version 2
	python_pkg_setup
}

src_prepare() {
	epatch \
		"${FILESDIR}"/0.14-python-version.patch \
		"${FILESDIR}"/0.14.1-testing.patch \
		"${FILESDIR}"/${PV}-unicode.patch
	echo '#!/bin/sh' > config/py-compile
}

src_configure() {
	econf \
		$(use_enable nls) \
		$(use_with X x) \
		--docdir="/usr/share/doc/${PF}" \
		--libdir="$(python_get_sitedir)" \
		--enable-site-packages
}

src_install() {
	default

	rm "${D}/usr/share/doc/${PF}/"{README.html,COPYING} || die
	dohtml README.html || die
}

pkg_postinst() {
	python_mod_optimize ${PN}
}

pkg_postrm() {
	python_mod_cleanup ${PN}
}
