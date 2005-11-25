# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-dns/avahi/avahi-0.6.1.ebuild,v 1.1 2005/11/25 07:38:25 swegener Exp $

inherit eutils qt3 mono python

DESCRIPTION="System which facilitates service discovery on a local network"
HOMEPAGE="http://www.freedesktop.org/Software/Avahi"
SRC_URI="http://www.freedesktop.org/~lennart/${P}.tar.gz"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~x86"
IUSE="howl-compat mdnsresponder-compat dbus doc mono gtk python qt"

RDEPEND="dev-libs/libdaemon
	dev-libs/expat
	qt? ( $(qt_min_version 3.3) )
	gtk? (
		>=x11-libs/gtk+-2
		>=gnome-base/libglade-2
		>=dev-libs/glib-2
	)
	mono? ( >=dev-lang/mono-1.1.3 )
	dbus? ( >=sys-apps/dbus-0.30 )
	python? (
		>=virtual/python-2.4
		gtk? ( >=dev-python/pygtk-2 )
	)
	dbus? (
		howl-compat? ( !net-misc/howl )
		mdnsresponder-compat? ( !net-misc/mDNSResponder )
	)"
DEPEND="${RDEPEND}
	doc? (
		app-doc/doxygen
		mono? ( >=dev-util/monodoc-1.1.8 )
	)"

export PKG_CONFIG_PATH="${QTDIR}/lib/pkgconfig"

pkg_setup() {
	if use python && ! built_with_use dev-lang/python gdbm
	then
		die "Need dev-lang/python compiled with gdbm support!"
	fi

	enewgroup avahi
	enewuser avahi -1 -1 -1 avahi
}

src_compile() {
	local myconf=""

	if use python
	then
		use dbus && myconf="${myconf} --enable-python-dbus"
		use gtk && myconf="${myconf} --enable-pygtk"
	fi

	if use mono && use doc
	then
		myconf="${myconf} --enable-monodoc"
	fi

	econf \
		--localstatedir=/var \
		--with-distro=gentoo \
		--disable-qt4 \
		--disable-python-dbus \
		--disable-pygtk \
		--disable-xmltoman \
		--disable-monodoc \
		$(use_enable mdnsresponder-compat compat-libdns_sd) \
		$(use_enable howl-compat compat-howl) \
		$(use_enable doc doxygen-doc) \
		$(use_enable mono) \
		$(use_enable dbus) \
		$(use_enable python) \
		$(use_enable gtk) \
		$(use_enable qt qt3) \
		$(use_enable gtk glib) \
		${myconf} \
		|| die "econf failed"
	emake -j1 || die "emake failed"
}

src_install() {
	make install DESTDIR="${D}" || die "make install failed"

	dodoc docs/{AUTHORS,README,TODO}
	rmdir "${D}"/Disabled &>/dev/null
}

pkg_postrm() {
	python_mod_cleanup "${ROOT}"/usr/lib/python*/site-packages/avahi
}

pkg_postinst() {
	python_mod_optimize "${ROOT}"/usr/lib/python*/site-packages/avahi
}
