# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-cpp/gtkmm/gtkmm-2.12.7.ebuild,v 1.9 2008/09/30 17:23:30 jer Exp $

inherit gnome2 eutils

DESCRIPTION="C++ interface for GTK+2"
HOMEPAGE="http://www.gtkmm.org"

LICENSE="LGPL-2.1"
SLOT="2.4"
KEYWORDS="alpha amd64 ~arm hppa ia64 ppc ~ppc64 ~sh sparc x86 ~x86-fbsd"
IUSE="accessibility doc examples test"

RDEPEND=">=dev-cpp/glibmm-2.14.1
	>=x11-libs/gtk+-2.12
	>=dev-cpp/cairomm-1.1.12
	>=dev-libs/libsigc++-2.0
	accessibility? ( >=dev-libs/atk-1.9.1 )"

DEPEND="${RDEPEND}
	dev-util/pkgconfig"

DOCS="AUTHORS CHANGES ChangeLog PORTING NEWS README"

pkg_setup() {
	G2CONF="${G2CONF}
		$(use_enable accessibility api-atkmm)
		$(use_enable doc docs)
		$(use_enable examples)
		$(use_enable examples demos)"
}

src_unpack() {
	gnome2_src_unpack

	# Fix build with gtk+-2.14
	epatch "${FILESDIR}/${P}-gtk2_14-compatibility.patch"

	if ! use test; then
		# don't waste time building tests
		sed -i 's/^\(SUBDIRS =.*\)tests\(.*\)$/\1\2/' Makefile.in || die "sed failed"
	fi
}
