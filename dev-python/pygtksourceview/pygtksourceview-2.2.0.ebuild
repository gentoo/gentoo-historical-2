# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-python/pygtksourceview/pygtksourceview-2.2.0.ebuild,v 1.1 2008/03/11 00:24:01 eva Exp $

NEED_PYTHON=2.3.5

inherit gnome2 python flag-o-matic multilib

DESCRIPTION="GTK+2 bindings for Python"
HOMEPAGE="http://www.pygtk.org/"

SRC_URI="${SRC_URI}"

LICENSE="LGPL-2.1"
SLOT="2"
KEYWORDS="~alpha ~amd64 ~arm ~hppa ~ia64 ~ppc ~ppc64 ~sh ~sparc ~x86 ~x86-fbsd"
IUSE="doc"

RDEPEND=">=dev-python/pygobject-2.11.3
	>=dev-python/pygtk-2.8
	>=x11-libs/gtksourceview-2.2"

DEPEND="${RDEPEND}
	doc? ( dev-libs/libxslt
		~app-text/docbook-xml-dtd-4.1.2
		>=app-text/docbook-xsl-stylesheets-1.70.1 )
	>=dev-util/pkgconfig-0.9"

pkg_setup() {
	G2CONF="$(use_enable doc docs)"
}

pkg_postinst() {
	python_version
	python_mod_optimize "${ROOT}"usr/$(get_libdir)/python${PYVER}/site-packages/
}

pkg_postrm() {
	python_version
	python_mod_optimize /usr/$(get_libdir)/python${PYVER}/site-packages/
}
