# Copyright 1999-2004 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-www/straw/straw-0.22.1.ebuild,v 1.5 2004/04/15 21:33:59 mr_bones_ Exp $

inherit gnome2 python distutils

DESCRIPTION="RSS/RDF News Aggregator"
HOMEPAGE="http://www.nongnu.org/straw/"
SRC_URI="http://savannah.nongnu.org/download/${PN}/${P}.tar.bz2"
LICENSE="GPL-2"

SLOT="0"
KEYWORDS="~x86 ~ppc ~amd64"
IUSE=""

DEPEND=">=dev-lang/python-2.2.3-r3"

RDEPEND="${DEPEND}
	>=gnome-base/libglade-2
	>=gnome-base/libgnome-2.0.1
	>=dev-python/gnome-python-1.99.13
	>=dev-python/pygtk-1.99.13-r1
	>=dev-python/bsddb3-3.4.0
	>=dev-python/egenix-mx-base-2
	!ppc? ( >=dev-python/adns-python-1.0.0 )"
# REMIND : egenix-mx-base is only needed for the conversion of
# pre 0.22 straw databases. It should be removed at some point.
# foser <foser@gentoo.org> 18 Feb 2004

pkg_setup() {
	if ! python -c 'import gtk; import gtkhtml2'; then
		eerror "The gnome-python gtkhtml2 module was not found."
		eerror "Rebuild gnome-python using:"
		eerror "  USE=\"gtkhtml\" emerge gnome-python"
		die "missing gtkhtml2 python module"
	fi
}

src_install() {

	distutils_src_install \
		--prefix=/usr \
		--sysconfdir=/etc \
		--disable-schemas-install

}

pkg_postinst() {

	distutils_pkg_postinst
	gnome2_pkg_postinst # need this for gconf schemas

	echo
	einfo "Consult the README if you have database conversion problems on startup."
	echo

}

pkg_postrm() {

	distutils_pkg_postrm
	gnome2_pkg_postrm

}
