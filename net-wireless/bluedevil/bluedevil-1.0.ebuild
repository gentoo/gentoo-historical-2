# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-wireless/bluedevil/bluedevil-1.0.ebuild,v 1.1 2011/01/02 17:31:20 dilfridge Exp $

EAPI="3"

inherit kde4-base

MY_P=${PN}-v${PV}

DESCRIPTION="Bluetooth stack for KDE"
HOMEPAGE="http://gitorious.org/bluedevil"
SRC_URI="http://media.ereslibre.es/2010/11/${MY_P}.tar.bz2"

LICENSE="GPL-3"
KEYWORDS="~amd64 ~x86"
SLOT="4"
IUSE="debug"

DEPEND="
	net-libs/libbluedevil
	x11-misc/shared-mime-info
"
RDEPEND="${DEPEND}
	!net-wireless/kbluetooth
	app-mobilephone/obexd
	app-mobilephone/obex-data-server
"

S=${WORKDIR}/${MY_P}
