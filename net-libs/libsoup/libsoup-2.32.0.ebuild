# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-libs/libsoup/libsoup-2.32.0.ebuild,v 1.1 2010/10/09 20:34:13 pacho Exp $

EAPI="3"
GCONF_DEBUG="yes"

inherit autotools eutils gnome2

DESCRIPTION="An HTTP library implementation in C"
HOMEPAGE="http://www.gnome.org/"

LICENSE="LGPL-2"
SLOT="2.4"
KEYWORDS="~alpha ~amd64 ~arm ~hppa ~ia64 ~ppc ~ppc64 ~sh ~sparc ~x86 ~x86-fbsd"
IUSE="debug doc +introspection gnome ssl test"

RDEPEND=">=dev-libs/glib-2.21.3
	>=dev-libs/libxml2-2
	introspection? ( >=dev-libs/gobject-introspection-0.9.5 )
	ssl? ( >=net-libs/gnutls-2.1.7 )"
DEPEND="${RDEPEND}
	>=dev-util/pkgconfig-0.9
	>=dev-util/gtk-doc-am-1.10
	doc? ( >=dev-util/gtk-doc-1.10 )"
#	test? (
#		www-servers/apache
#		dev-lang/php
#		net-misc/curl )
PDEPEND="gnome? ( ~net-libs/${PN}-gnome-${PV} )"

DOCS="AUTHORS NEWS README"

pkg_setup() {
	G2CONF="${G2CONF}
		--disable-static
		--without-gnome
		$(use_enable introspection)
		$(use_enable ssl)"
}

src_configure() {
	# FIXME: we need addpredict to workaround bug #324779 until
	# root cause (bug #249496) is solved
	addpredict /usr/share/snmp/mibs/.index
	gnome2_src_configure
}

src_prepare() {
	gnome2_src_prepare

	if ! use test; then
		# don't waste time building tests (bug #226271)
		sed 's/^\(SUBDIRS =.*\)tests\(.*\)$/\1\2/' -i Makefile.am Makefile.in \
			|| die "sed failed"
	fi

	# Patch *must* be applied conditionally (see patch for details)
	if use doc; then
		# Fix bug 268592 (build fails !gnome && doc)
		epatch "${FILESDIR}/${PN}-2.30.1-fix-build-without-gnome-with-doc.patch"
		eautoreconf
	fi
}
