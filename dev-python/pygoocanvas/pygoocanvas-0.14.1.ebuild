# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-python/pygoocanvas/pygoocanvas-0.14.1.ebuild,v 1.8 2011/03/22 19:03:24 ranger Exp $

EAPI="3"
GCONF_DEBUG="no"
PYTHON_DEPEND="2"
SUPPORT_PYTHON_ABIS="1"
RESTRICT_PYTHON_ABIS="3.* *-jython"
PYTHON_EXPORT_PHASE_FUNCTIONS="1"

inherit gnome2 python

DESCRIPTION="GooCanvas python bindings"
HOMEPAGE="http://live.gnome.org/PyGoocanvas"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ppc x86"
IUSE="doc examples"

RDEPEND=">=dev-python/pygobject-2.11.3:2
	>=dev-python/pygtk-2.10.4:2
	>=dev-python/pycairo-1.8.4
	>=x11-libs/goocanvas-0.14:0"
DEPEND="${RDEPEND}
	dev-util/pkgconfig
	doc? (
		dev-libs/libxslt
		dev-util/gtk-doc )"

DOCS="AUTHORS ChangeLog NEWS"

pkg_setup() {
	G2CONF="${G2CONF}
		$(use_enable doc docs)"
	python_pkg_setup
}

src_prepare() {
	sed -e 's/^\(SUBDIRS =.*\)demo\(.*\)$/\1\2/' \
		-i Makefile.am Makefile.in || die "sed 1 failed"
	python_src_prepare
}

src_configure() {
	python_execute_function -s gnome2_src_configure
}

src_install() {
	python_execute_function -s gnome2_src_install
	python_clean_installation_image

	if use examples; then
		rm demo/Makefile*
		cp -R demo "${D}"/usr/share/doc/${PF}
	fi
}
