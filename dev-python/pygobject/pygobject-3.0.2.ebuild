# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-python/pygobject/pygobject-3.0.2.ebuild,v 1.14 2012/03/05 22:01:12 ranger Exp $

EAPI="4"
GCONF_DEBUG="no"
GNOME2_LA_PUNT="yes"
SUPPORT_PYTHON_ABIS="1"
PYTHON_DEPEND="2:2.6 3:3.1"
RESTRICT_PYTHON_ABIS="2.4 2.5 3.0 *-jython 2.7-pypy-*"

# XXX: Is the alternatives stuff needed anymore?
inherit alternatives autotools gnome2 python virtualx

DESCRIPTION="GLib's GObject library bindings for Python"
HOMEPAGE="http://www.pygtk.org/"

LICENSE="LGPL-2.1"
SLOT="3"
KEYWORDS="~alpha amd64 arm hppa ~ia64 ~mips ppc ppc64 ~sh ~sparc x86 ~x86-fbsd ~x86-interix ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~x86-macos ~sparc-solaris ~x64-solaris ~x86-solaris"
IUSE="+cairo examples test +threads" # doc

COMMON_DEPEND=">=dev-libs/glib-2.24.0:2
	>=dev-libs/gobject-introspection-1.29
	virtual/libffi
	cairo? ( >=dev-python/pycairo-1.10.0 )"
DEPEND="${COMMON_DEPEND}
	test? (
		media-fonts/font-cursor-misc
		media-fonts/font-misc-misc
		>=dev-libs/gobject-introspection-1.29.17 )
	>=dev-util/pkgconfig-0.12"
# docs disabled for now per upstream default since they are very out of date
#	doc? (
#		app-text/docbook-xml-dtd:4.1.2
#		dev-libs/libxslt
#		>=app-text/docbook-xsl-stylesheets-1.70.1 )

# We now disable introspection support in slot 2 per upstream recommendation
# (see https://bugzilla.gnome.org/show_bug.cgi?id=642048#c9); however,
# older versions of slot 2 installed their own site-packages/gi, and
# slot 3 will collide with them.
RDEPEND="${COMMON_DEPEND}
	!<dev-python/pygtk-2.13
	!<dev-python/pygobject-2.28.6-r50:2[introspection]"

pkg_setup() {
	DOCS="AUTHORS ChangeLog* NEWS README"
	# Hard-enable libffi support since both gobject-introspection and
	# glib-2.29.x rdepend on it anyway
	G2CONF="${G2CONF}
		--disable-dependency-tracking
		--with-ffi
		$(use_enable cairo)
		$(use_enable threads thread)"

	python_pkg_setup
}

src_prepare() {
	# Do not build tests if unneeded, bug #226345
	epatch "${FILESDIR}/${PN}-2.90.1-make_check.patch"

	# Support installation for multiple Python versions, upstream bug #648292
	epatch "${FILESDIR}/${PN}-3.0.0-support_multiple_python_versions.patch"

	# Disable tests that fail
	#epatch "${FILESDIR}/${PN}-2.28.3-disable-failing-tests.patch"

	# FIXME: disable tests that require git master of gobject-introspection
	epatch "${FILESDIR}/${P}-disable-new-gi-tests.patch"

	# disable pyc compiling
	echo '#!/bin/sh' > py-compile

	eautoreconf
	gnome2_src_prepare

	python_copy_sources
}

src_configure() {
	python_execute_function -s gnome2_src_configure
}

src_compile() {
	python_execute_function -d -s
}

# FIXME: With python multiple ABI support, tests return 1 even when they pass
src_test() {
	unset DBUS_SESSION_BUS_ADDRESS

	testing() {
		XDG_CACHE_HOME="${T}/$(PYTHON --ABI)"
		Xemake check PYTHON=$(PYTHON -a)
	}
	python_execute_function -s testing
}

src_install() {
	python_execute_function -s gnome2_src_install
	python_clean_installation_image

	if use examples; then
		insinto /usr/share/doc/${P}
		doins -r examples || die "doins failed"
	fi
}

pkg_postinst() {
	python_mod_optimize gi
}

pkg_postrm() {
	python_mod_cleanup gi
}
