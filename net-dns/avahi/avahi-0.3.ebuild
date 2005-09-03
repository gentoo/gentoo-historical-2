# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-dns/avahi/avahi-0.3.ebuild,v 1.2 2005/09/03 17:55:31 swegener Exp $

inherit eutils qt3

DESCRIPTION="System which facilitates service discovery on a local network"
HOMEPAGE="http://www.freedesktop.org/Software/Avahi"
SRC_URI="http://www.freedesktop.org/~lennart/${P}.tar.gz"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="dbus doc gtk python qt"

RDEPEND="dev-libs/libdaemon
	dev-libs/expat
	qt? ( $(qt_min_version 3.3) )
	gtk? (
		>=x11-libs/gtk+-2
		>=gnome-base/libglade-2
		>=dev-libs/glib-2
	)
	dbus? (
		>=sys-apps/dbus-0.30
		python? (
			>=virtual/python-2.4
			>=dev-python/pygtk-2
		)
	)"
DEPEND="${RDEPEND}
	doc? ( app-doc/doxygen )"

pkg_setup() {
	enewgroup avahi
	enewuser avahi -1 -1 -1 avahi
}

src_unpack() {
	unpack ${A}
	cd "${S}"

	epatch "${FILESDIR}"/0.2-anydbm.patch
}

src_compile() {
	local myconf=""

	if use python && use dbus
	then
		myconf="${myconf} --enable-python"
	fi

	econf \
		--localstatedir=/var \
		--with-distro=gentoo \
		--disable-xmltoman \
		--disable-python \
		--disable-qt4 \
		$(use_enable doc doxygen-doc) \
		$(use_enable dbus) \
		$(use_enable gtk) \
		$(use_enable qt qt3) \
		$(use_enable gtk glib) \
		${myconf} \
		|| die "econf failed"
	emake || die "emake failed"
}

src_install() {
	make install DESTDIR="${D}" || die "make install failed"

	dodoc docs/{AUTHORS,README,TODO}
}
