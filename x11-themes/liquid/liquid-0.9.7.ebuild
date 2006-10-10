# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/x11-themes/liquid/liquid-0.9.7.ebuild,v 1.8 2006/10/10 08:47:14 deathwing00 Exp $

inherit kde

WANT_AUTOMAKE="1.6"
WANT_AUTOCONF="2.1"

DESCRIPTION="Liquid theme, revamped for KDE 3.2"
HOMEPAGE="http://developer.berlios.de/projects/liquid/"
SRC_URI="http://download.berlios.de/liquid/${P}.tar.bz2
		mirror://gentoo/kde-admindir-3.5.3.tar.bz2"
LICENSE="BSD"

SLOT="0"
KEYWORDS="amd64 x86"
IUSE=""

DEPEND="|| ( kde-base/kwin >=kde-base/kdebase-3.2 )"

need-kde 3.2

src_unpack() {
	unpack ${A}
	cd "${S}"
	rm -rf "${S}/admin" "${S}/configure"
	ln -s "${WORKDIR}/admin" "${S}/admin"
}

