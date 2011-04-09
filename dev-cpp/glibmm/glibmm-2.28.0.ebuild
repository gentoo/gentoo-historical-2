# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-cpp/glibmm/glibmm-2.28.0.ebuild,v 1.2 2011/04/09 07:04:33 nirbheek Exp $

EAPI="3"
GCONF_DEBUG="no"

inherit gnome2

DESCRIPTION="C++ interface for glib2"
HOMEPAGE="http://www.gtkmm.org"

LICENSE="|| ( LGPL-2.1 GPL-2 )"
SLOT="2"
KEYWORDS="~alpha ~amd64 ~arm ~hppa ~ia64 ~mips ~ppc ~ppc64 ~sh ~sparc ~x86 ~x86-fbsd ~amd64-linux ~x86-linux ~ppc-macos ~x86-macos ~x86-solaris"
IUSE="doc debug examples test"

RDEPEND=">=dev-libs/libsigc++-2.2:2
	>=dev-libs/glib-2.28:2"
DEPEND="${RDEPEND}
	dev-util/pkgconfig
	doc? ( app-doc/doxygen )"

pkg_setup() {
	DOCS="AUTHORS ChangeLog NEWS README"
	G2CONF="${G2CONF}
		$(use_enable debug debug-refcounting)
		$(use_enable doc documentation)
		--disable-schemas-compile
		--enable-deprecated-api"
}

src_prepare() {
	gnome2_src_prepare

	if ! use test; then
		# don't waste time building tests
		sed 's/^\(SUBDIRS =.*\)tests\(.*\)$/\1\2/' \
			-i Makefile.am Makefile.in || die "sed 1 failed"
	fi

	if ! use examples; then
		# don't waste time building examples
		sed 's/^\(SUBDIRS =.*\)examples\(.*\)$/\1\2/' \
			-i Makefile.am Makefile.in || die "sed 2 failed"
	fi
}

src_test() {
	cd "${S}/tests/"
	emake check || die "emake check failed"

	for i in */test; do
		${i} || die "Running tests failed at ${i}"
	done
}

src_install() {
	gnome2_src_install

	if ! use doc && ! use examples; then
		rm -fr "${ED}usr/share/doc/glibmm*"
	fi

	if use examples; then
		find examples -type d -name '.deps' -exec rm -rf {} \; 2>/dev/null
		dodoc examples
	fi

	# Remove useless .la files
	find "${D}" -name '*.la' -exec rm -f {} + || die
}
