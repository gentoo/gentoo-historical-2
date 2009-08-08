# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sci-chemistry/gchemutils/gchemutils-0.10.3.ebuild,v 1.3 2009/08/08 08:44:25 ssuominen Exp $

EAPI=2
GCONF_DEBUG=no
MY_P=gnome-chemistry-utils-${PV}

inherit autotools eutils gnome2

DESCRIPTION="C++ classes and Gtk+-2 widgets related to chemistry"
HOMEPAGE="http://www.nongnu.org/gchemutils/"
SRC_URI="http://savannah.nongnu.org/download/gchemutils/0.10/${MY_P}.tar.bz2"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND="gnome-base/libglade:2.0
	>=gnome-base/libgnomeprintui-2.4
	>=gnome-extra/libgsf-1.14[gnome]
	>=x11-libs/goffice-0.6.5:0.6[gnome]
	x11-libs/gtkglext
	app-text/gnome-doc-utils
	>=sci-chemistry/openbabel-2.1.1
	sci-chemistry/bodr
	sci-chemistry/chemical-mime-data"
DEPEND="${RDEPEND}
	dev-util/pkgconfig
	app-text/rarian
	dev-util/intltool
	!sci-chemistry/gchempaint"

S=${WORKDIR}/${MY_P}

src_prepare() {
	gnome2_src_prepare
	epatch "${FILESDIR}"/${P}-glibc-2.10.patch
	eautoreconf
}

src_configure() {
	gnome2_src_configure \
		--docdir=/usr/share/doc/${PN}/html \
		--disable-update-databases \
		--disable-mozilla-plugin
}

pkg_postinst() {
	elog "You can safely ignore any 'Unknown media type in type blah' warnings above."
	elog "For more info see http://bugs.debian.org/cgi-bin/bugreport.cgi?bug=420795 "
}
