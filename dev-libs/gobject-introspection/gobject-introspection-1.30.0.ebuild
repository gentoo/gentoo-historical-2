# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-libs/gobject-introspection/gobject-introspection-1.30.0.ebuild,v 1.3 2011/12/31 21:58:21 tetromino Exp $

EAPI="3"
GCONF_DEBUG="no"
GNOME_TARBALL_SUFFIX="xz"
GNOME2_LA_PUNT="yes"
PYTHON_DEPEND="2:2.5"

inherit gnome2 python

DESCRIPTION="Introspection infrastructure for generating gobject library bindings for various languages"
HOMEPAGE="http://live.gnome.org/GObjectIntrospection/"

LICENSE="LGPL-2 GPL-2"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~hppa ~ia64 ~mips ~ppc ~ppc64 ~s390 ~sh ~sparc ~x86
~x86-fbsd ~x86-freebsd ~x86-interix ~amd64-linux ~x86-linux ~ppc-macos
~x64-macos ~x86-macos ~sparc-solaris ~sparc64-solaris ~x64-solaris ~x86-solaris"

IUSE="doc test"

RDEPEND=">=dev-libs/glib-2.29.7:2
	virtual/libffi"
DEPEND="${RDEPEND}
	dev-util/pkgconfig
	sys-devel/flex
	virtual/yacc
	doc? ( >=dev-util/gtk-doc-1.15 )
	test? ( x11-libs/cairo )"

pkg_setup() {
	DOCS="AUTHORS CONTRIBUTORS ChangeLog NEWS README TODO"
	G2CONF="${G2CONF}
		--disable-static
		YACC=$(type -p yacc)
		$(use_enable test tests)"

	python_set_active_version 2
}

src_prepare() {
	# https://bugzilla.gnome.org/show_bug.cgi?id=659824
	sed -i -e '/^TAGS/s/[{}]//g' "${S}/giscanner/docbookdescription.py" || die

	# FIXME: Parallel compilation failure with USE=doc
	use doc && MAKEOPTS="-j1"

	# Don't pre-compile .py
	echo '#!/bin/sh' > py-compile
	echo '#!/bin/sh' > build-aux/py-compile

	gnome2_src_prepare
}

src_install() {
	gnome2_src_install
	python_convert_shebangs 2 "${ED}"usr/bin/g-ir-{annotation-tool,doc-tool,scanner}
}

pkg_postinst() {
	python_mod_optimize /usr/$(get_libdir)/${PN}/giscanner
	python_need_rebuild
}

pkg_postrm() {
	python_mod_cleanup /usr/lib*/${PN}/giscanner
}
