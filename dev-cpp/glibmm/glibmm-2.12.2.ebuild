# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-cpp/glibmm/glibmm-2.12.2.ebuild,v 1.1 2006/10/28 23:56:28 allanonjl Exp $

inherit gnome2

DESCRIPTION="C++ interface for glib2"
HOMEPAGE="http://gtkmm.sourceforge.net/"

LICENSE="LGPL-2.1"
SLOT="2"
KEYWORDS="~alpha ~amd64 ~hppa ~ia64 ~ppc ~ppc64 ~sparc ~x86"
IUSE="doc examples"

RDEPEND=">=dev-libs/libsigc++-2.0.11
	>=dev-libs/glib-2.9"

DEPEND="${RDEPEND}
	dev-util/pkgconfig
	doc? ( app-doc/doxygen )"

DOCS="AUTHORS CHANGES ChangeLog NEWS README"

src_unpack() {
	gnome2_src_unpack

	if ! use examples; then
		# don't waste time building the examples
		sed -i 's/^\(SUBDIRS =.*\)examples\(.*\)$/\1\2/' Makefile.in || \
			die "sed Makefile.in failed"
	fi
}

src_install() {
	gnome2_src_install

	if ! use doc && ! use examples; then
		rm -fr ${D}/usr/share/doc/glibmm-2.4
	fi

	if use examples; then
		find examples -type d -name '.deps' -exec rm -fr {} \; 2>/dev/null
		cp -R examples ${D}/usr/share/doc/${PF}
	fi
}
