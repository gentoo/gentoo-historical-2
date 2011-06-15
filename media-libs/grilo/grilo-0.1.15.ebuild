# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-libs/grilo/grilo-0.1.15.ebuild,v 1.2 2011/06/15 16:37:18 pacho Exp $

EAPI="4"
GNOME2_LA_PUNT="yes"
GNOME_TARBALL_SUFFIX="bz2"

inherit autotools eutils gnome2

DESCRIPTION="A framework for easy media discovery and browsing"
HOMEPAGE="https://live.gnome.org/Grilo"
SRC_URI="${SRC_URI}
	mirror://gentoo/${P}-patches-0.1.tar.xz"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="doc +introspection +network test test-ui vala"

RDEPEND="
	>=dev-libs/glib-2.22:2
	dev-libs/libxml2:2
	network? ( >=net-libs/libsoup-2.33.4:2.4 )
	test-ui? ( >=x11-libs/gtk+-3.0:3 )
	introspection? ( >=dev-libs/gobject-introspection-0.9 )"
DEPEND="${RDEPEND}
	>=dev-util/pkgconfig-0.9
	doc? ( >=dev-util/gtk-doc-1.10 )
	vala? ( dev-lang/vala:0.12[vapigen] )
	test? (
		dev-python/pygobject:2[introspection?]
		media-plugins/grilo-plugins )"

pkg_setup() {
	DOCS="AUTHORS NEWS README TODO"
	# --enable-debug only changes CFLAGS, useless for us
	G2CONF="${G2CONF}
		--disable-maintainer-mode
		--disable-static
		--disable-debug
		VALAC=$(type -P valac-0.12)
		VALA_GEN_INTROSPECT=$(type -P vala-gen-introspect-0.12)
		VAPIGEN=$(type -P vapigen-0.12)
		$(use_enable introspection)
		$(use_enable network grl-net)
		$(use_enable test tests)
		$(use_enable test-ui)
		$(use_enable vala)"
}

src_prepare() {
	# Various patches from upstream trunk
	epatch "${WORKDIR}"/*.patch
	# Build system doesn't install this file with the tarball
	cp "${WORKDIR}/constants.py" "${S}/tests/python/"
	eautoreconf

	gnome2_src_prepare
}

src_test() {
	cd tests/
	emake check
}
