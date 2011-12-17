# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-libs/memphis/memphis-0.2.3.ebuild,v 1.7 2011/12/17 14:13:39 jlec Exp $

EAPI=4

WANT_AUTOMAKE=1.11

inherit autotools-utils

DESCRIPTION="A map-rendering application and a library for OpenStreetMap"
HOMEPAGE="http://trac.openstreetmap.ch/trac/memphis/"
SRC_URI="http://wenner.ch/files/public/mirror/${PN}/${P}.tar.gz"

LICENSE="LGPL-2.1"
SLOT="0.2"
KEYWORDS="amd64 x86"
IUSE="debug doc +introspection vala static-libs"

RDEPEND="
	dev-libs/expat
	dev-libs/glib:2
	x11-libs/cairo
	introspection? ( dev-libs/gobject-introspection )
	vala? ( dev-lang/vala:0.12 )"
DEPEND="${RDEPEND}
	doc? ( >=dev-util/gtk-doc-1.12 )"

AUTOTOOLS_IN_SOURCE_BUILD=1

DOCS=(AUTHORS ChangeLog NEWS README)

PATCHES=(
	"${FILESDIR}"/${P}-link_gobject.patch
	)

src_prepare() {
	autotools-utils_src_prepare
	eautoreconf
}

src_configure() {
	unset VALAC
	use vala && export VALAC=$(type -p valac-0.12)

	local myeconfargs=(
		$(use_enable debug)
		$(use_enable doc gtk-doc)
		$(use_enable introspection)
		$(use_enable vala)
	)
	CFLAGS="${CFLAGS}" \
		autotools-utils_src_configure
}
