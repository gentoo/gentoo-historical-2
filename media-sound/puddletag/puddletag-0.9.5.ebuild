# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-sound/puddletag/puddletag-0.9.5.ebuild,v 1.1 2010/10/09 19:04:55 billie Exp $

EAPI=2

PYTHON_DEPEND=2
PYTHON_MODNAME=puddlestuff

inherit distutils fdo-mime python

DESCRIPTION="Audio tag editor"
HOMEPAGE="http://puddletag.sourceforge.net/"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~x86"
IUSE="cover quodlibet"

DEPEND=""
RDEPEND=">=dev-python/PyQt4-4.5
	>=dev-python/pyparsing-1.4
	>=media-libs/mutagen-1.17
	>=dev-python/configobj-4.7.2
	>=dev-python/python-musicbrainz-0.7.0
	cover? ( >=dev-python/imaging-1.1.7 )
	quodlibet? ( >=media-sound/quodlibet-2.2.1 )"

pkg_setup() {
	python_set_active_version 2
	python_pkg_setup
}

src_prepare() {
	python_convert_shebangs -q -r 2 .
	distutils_src_prepare
}

pkg_postinst() {
	fdo-mime_desktop_database_update
	distutils_pkg_postinst
}

pkg_postrm() {
	fdo-mime_desktop_database_update
	distutils_pkg_postrm
}
