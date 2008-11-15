# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/x11-apps/simple-ccsm/simple-ccsm-0.7.8.ebuild,v 1.2 2008/11/15 02:00:49 jmbsvicetto Exp $

inherit gnome2-utils

DESCRIPTION="Simplified Compizconfig Settings Manager"
HOMEPAGE="http://compiz-fusion.org"
SRC_URI="http://releases.compiz-fusion.org/${PV}/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="gtk"

DEPEND="~dev-python/compizconfig-python-${PV}
	>=dev-python/pygtk-2.10
	~x11-apps/ccsm-${PV}"

src_compile() {
	./setup.py build --prefix=/usr
}

src_install() {
	./setup.py install --root="${D}" --prefix=/usr
}

pkg_postinst() {
	use gtk && gnome2_icon_cache_update
}
