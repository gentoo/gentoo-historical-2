# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-gfx/mirage/mirage-0.8.ebuild,v 1.1 2006/10/19 00:16:49 omp Exp $

inherit distutils

DESCRIPTION="Fast and simple GTK+ image viewer"
HOMEPAGE="http://mirageiv.berlios.de/"
SRC_URI="http://download.berlios.de/mirageiv/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND=">=dev-python/pygtk-2.6"

src_install() {
	distutils_src_install

	# Don't install duplicate ungzipped docs.
	rm -rf "${D}/usr/share/mirage/"{CHANGELOG,COPYING,README}
}
