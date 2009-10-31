# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/kde-misc/kcm_touchpad/kcm_touchpad-0.3.0.ebuild,v 1.1 2009/10/31 13:46:02 ssuominen Exp $

EAPI=2
KDE_LINGUAS="es nl pl"
inherit kde4-base

MY_P=mishaaq-${PN}-000be4c

DESCRIPTION="KControl module for xf86-input-synaptics"
HOMEPAGE="http://www.kde-apps.org/content/show.php/kcm_touchpad?content=113335"
SRC_URI="http://github.com/mishaaq/kcm_touchpad/tarball/${P} -> ${MY_P}.tar.gz"

LICENSE="GPL-2"
SLOT="4"
KEYWORDS="~amd64 ~x86"
IUSE="debug"

DEPEND="x11-libs/libXi"

S=${WORKDIR}/${MY_P}

DOCS="AUTHORS README"

src_install() {
	kde4-base_src_install
	rm -rf "${D}"usr/share/doc/${PN}
}
