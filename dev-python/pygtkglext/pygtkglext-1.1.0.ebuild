# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-python/pygtkglext/pygtkglext-1.1.0.ebuild,v 1.22 2010/04/10 20:10:16 arfrever Exp $

EAPI="3"
PYTHON_DEPEND="2"
SUPPORT_PYTHON_ABIS="1"
PYTHON_EXPORT_PHASE_FUNCTIONS="1"

inherit python

DESCRIPTION="Python bindings to GtkGLExt"
HOMEPAGE="http://gtkglext.sourceforge.net/"
SRC_URI="mirror://sourceforge/gtkglext/${P}.tar.bz2"

LICENSE="LGPL-2.1 GPL-2"
SLOT="0"
KEYWORDS="alpha amd64 arm hppa ia64 ppc ppc64 sh sparc x86 ~x86-fbsd"
IUSE="examples"

RDEPEND=">=dev-python/pygtk-2.8
	>=dev-libs/glib-2.0
	>=x11-libs/gtk+-2.0
	>=x11-libs/gtkglext-1.0.0
	dev-python/pyopengl
	virtual/opengl
	virtual/glu"
DEPEND="${RDEPEND}
	dev-util/pkgconfig"
RESTRICT_PYTHON_ABIS="3.*"

src_prepare() {
	# Disable byte-compilation.
	mv py-compile py-compile.orig
	ln -s $(type -P true) py-compile

	python_copy_sources
}

src_install() {
	python_src_install
	python_clean_sitedirs

	dodoc README AUTHORS ChangeLog

	if use examples; then
		insinto /usr/share/doc/${PF}/examples
		doins examples/*.{py,png}
	fi
}

pkg_postinst() {
	python_mod_optimize gtk-2.0
}

pkg_postrm() {
	python_mod_cleanup gtk-2.0
}
