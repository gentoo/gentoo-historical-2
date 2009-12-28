# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-misc/gourmet/gourmet-0.15.0.ebuild,v 1.2 2009/12/28 21:19:51 maekke Exp $

EAPI="2"

inherit distutils

DESCRIPTION="Recipe Organizer and Shopping List Generator for Gnome"
HOMEPAGE="http://grecipe-manager.sourceforge.net/"
SRC_URI="mirror://sourceforge/grecipe-manager/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE="gnome-print pdf rtf"

RDEPEND=">=dev-lang/python-2.4
	>=dev-python/pygtk-2.3.93
	>=dev-python/libgnome-python-2
	>=gnome-base/libglade-2
	|| ( >=dev-lang/python-2.5[sqlite]
	     >=dev-python/pysqlite-2 )
	>=dev-python/sqlalchemy-0.5.5
	dev-python/imaging
	dev-db/metakit[python]
	pdf? ( dev-python/reportlab )
	rtf? ( dev-python/pyrtf )
	gnome-print? ( >=dev-python/libgnomeprint-python-2 )"
DEPEND="${RDEPEND}"

# distutils gets a bunch of default docs
DOCS="TESTS FAQ"

src_prepare() {
	epatch "${FILESDIR}/${P}-empty_dictionary_insert.patch"
}

src_install() {
	distutils_src_install --disable-modules-check
	doman gourmet.1
}
