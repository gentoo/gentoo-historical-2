# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-cpp/bakery/bakery-2.6.2.ebuild,v 1.1 2009/01/05 22:01:44 eva Exp $

inherit gnome2

DESCRIPTION="Bakery is a C++ Framework for creating GNOME applications using gtkmm."
HOMEPAGE="http://bakery.sourceforge.net/"
LICENSE="GPL-2"

SLOT="2.6"
KEYWORDS="~amd64 ~ppc ~x86"
IUSE="doc examples"

RDEPEND=">=dev-cpp/gtkmm-2.10
	>=dev-cpp/gconfmm-2.6
	>=dev-cpp/libglademm-2.4
	>=dev-cpp/libxmlpp-2.8
	>=dev-cpp/glibmm-2.16"
DEPEND="${RDEPEND}
	>=dev-util/intltool-0.25
	>=dev-util/pkgconfig-0.12"

DOCS="AUTHORS COPYING ChangeLog INSTALL NEWS README"

pkg_setup() {
	G2CONF="${G2CONF} --disable-option-checking --disable-maemo"
}

src_unpack() {
	gnome2_src_unpack

	#sed -i "/AM_INIT/ a \AM_MAINTAINER_MODE" configure.in || \
	#	die "sed maintainer-mode failed"

	# should be configured via configure switch
	if ! use examples ; then
		sed 's/^\(SUBDIRS =.*\)examples\(.*\)$/\1\2/' \
			-i Makefile.am Makefile.in || \
			die "sed Makefile.am failed"
	fi

	#eautoreconf
}

src_install() {
	gnome2_src_install
	use doc && dohtml docs/*.html docs/reference/*.html
}
