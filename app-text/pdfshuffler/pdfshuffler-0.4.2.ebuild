# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-text/pdfshuffler/pdfshuffler-0.4.2.ebuild,v 1.3 2010/05/18 13:03:48 hwoarang Exp $

EAPI=2

inherit gnome2-utils fdo-mime distutils

DESCRIPTION="PDF-Shuffler is GUI app that can merge or split pdfs and rotate, crop and rearrange their pages."
HOMEPAGE="http://sourceforge.net/projects/pdfshuffler/"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.gz"

LICENSE="GPL-2"

SLOT="0"

KEYWORDS="amd64 x86"

IUSE=""

DEPEND="dev-python/python-poppler
	dev-python/pyPdf"
RDEPEND="${DEPEND}"
S="${WORKDIR}/${P}"

DOCS="ChangeLog README TODO AUTHORS"

pkg_preinst() {
	gnome2_icon_savelist
}

pkg_postinst() {
	distutils_pkg_postinst
	fdo-mime_desktop_database_update
	fdo-mime_mime_database_update
	gnome2_icon_cache_update
}

pkg_postrm() {
	distutils_pkg_postrm
	fdo-mime_desktop_database_update
	fdo-mime_mime_database_update
	gnome2_icon_cache_update
}
