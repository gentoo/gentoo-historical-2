# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/x11-apps/ccsm/ccsm-0.7.8.ebuild,v 1.1 2008/10/27 01:05:28 jmbsvicetto Exp $

inherit gnome2-utils

DESCRIPTION="Compizconfig Settings Manager"
HOMEPAGE="http://compiz-fusion.org"
SRC_URI="http://releases.compiz-fusion.org/${PV}/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""
RESTRICT="mirror"

DEPEND="~dev-python/compizconfig-python-${PV}
	>=dev-python/pygtk-2.10"

src_compile() {
	./setup.py build --prefix=/usr
}

src_install() {
	./setup.py install --root="${D}" --prefix=/usr
}

pkg_postinst() {
	if use gtk ; then gnome2_icon_cache_update ; fi

	ewarn "DO NOT report bugs to Gentoo's bugzilla"
	einfo "Please report all bugs to #gentoo-desktop-effects"
	einfo "Thank you on behalf of the Gentoo Desktop-Effects team"
}
