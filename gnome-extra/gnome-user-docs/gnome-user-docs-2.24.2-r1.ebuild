# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/gnome-extra/gnome-user-docs/gnome-user-docs-2.24.2-r1.ebuild,v 1.1 2009/02/28 12:54:12 eva Exp $

GCONF_DEBUG="no"

inherit autotools eutils gnome2

DESCRIPTION="GNOME end user documentation"
HOMEPAGE="http://www.gnome.org/"

LICENSE="FDL-1.1"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~hppa ~ia64 ~ppc ~ppc64 ~sparc ~x86 ~x86-fbsd"
IUSE=""

RDEPEND=""
DEPEND="app-text/scrollkeeper
	>=app-text/gnome-doc-utils-0.5.6
	>=dev-util/pkgconfig-0.9"
#	test? (
#		~app-text/docbook-xml-dtd-4.1.2
#		~app-text/docbook-xml-dtd-4.3 )"

DOCS="AUTHORS ChangeLog NEWS README"

# Fails to validate, upstream bug #535906
RESTRICT="test"

pkg_setup() {
	G2CONF="${G2CONF} --disable-scrollkeeper"
}

src_unpack() {
	gnome2_src_unpack

	# Fix parallel make, bug #252163
	epatch "${FILESDIR}/${P}-parallel-make.patch"
	epatch "${FILESDIR}/${P}-parallel-make-gdu.patch"

	# Ugly ugly hack but gnome-doc-utils isn't actually
	# parallel make safe.
	sed "s/install-data-local/install-data-hook/" \
		-i gnome-doc-utils.make || die "sed failed"

	eautoreconf
}
