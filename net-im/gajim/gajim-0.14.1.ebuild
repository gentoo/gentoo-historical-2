# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-im/gajim/gajim-0.14.1.ebuild,v 1.2 2010/10/29 14:27:45 jlec Exp $

EAPI="2"

PYTHON_DEPEND="2"
PYTHON_USE_WITH="sqlite xml"
SUPPORT_PYTHON_ABIS="1"
RESTRICT_PYTHON_ABIS="3.*"

inherit eutils python versionator

DESCRIPTION="Jabber client written in PyGTK"
HOMEPAGE="http://www.gajim.org/"
SRC_URI="http://www.gajim.org/downloads/$(get_version_component_range 1-2)/${P}.tar.bz2"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~hppa ~ia64 ~ppc ~ppc64 ~sparc ~x86 ~x86-fbsd"
IUSE="avahi crypt dbus gnome idle jingle libnotify networkmanager nls spell srv X xhtml"

COMMON_DEPEND="
	x11-libs/gtk+:2
	>=dev-python/pygtk-2.16.0"

DEPEND="${COMMON_DEPEND}
	>=sys-devel/gettext-0.17-r1
	>=dev-util/intltool-0.40.1
	dev-util/pkgconfig"

RDEPEND="${COMMON_DEPEND}
	dev-python/pyopenssl
	dev-python/sexy-python
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
	gnome? (
		dev-python/libgnome-python
		dev-python/gnome-keyring-python
		dev-python/egg-python
		)
	idle? ( x11-libs/libXScrnSaver )
	jingle? ( net-libs/farsight2[python] )
	networkmanager? (
			dev-python/dbus-python
			|| ( >=net-misc/networkmanager-0.7.1 net-misc/networkmanager[gnome] )
		)
	srv? (
		|| (
			dev-python/libasyncns-python
			net-dns/bind-tools )
		)
	spell? ( app-text/gtkspell )
	xhtml? ( dev-python/docutils )"

pkg_setup() {
	if ! use dbus; then
		if use libnotify; then
			eerror "The dbus USE flag is required for libnotify support"
			die "USE=\"dbus\" needed for libnotify support"
		fi
		if use avahi; then
			eerror "The dbus USE flag is required for avahi support"
			die "USE=\"dbus\" needed for avahi support"
		fi
	fi
	python_pkg_setup
}

src_prepare() {
	epatch \
		"${FILESDIR}"/0.14-python-version.patch \
		"${FILESDIR}"/0.14.1-testing.patch
	echo '#!/bin/sh' > config/py-compile

}

src_configure() {
	econf \
		$(use_enable nls) \
		$(use_with X x) \
		--docdir="/usr/share/doc/${PF}" \
		--enable-site-packages
}

src_test() {
	testing() {
		emake \
			GENTOOPY="$(PYTHON)" \
			test || die
	}
# not implemented
#	python_execute_function testing
}

src_install() {
	installation() {
		emake \
			GAJIM_SRCDIR="$(python_get_sitedir)"/${PN} \
			pythondir="$(python_get_sitedir)" \
			pyexecdir="$(python_get_sitedir)" \
			DESTDIR="${D}" \
			install || die
	}

	python_execute_function installation

	rm "${D}/usr/share/doc/${PF}/"{README.html,COPYING} || die
	dohtml README.html || die
}
