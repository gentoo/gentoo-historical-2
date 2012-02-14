# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-p2p/tribler/tribler-5.5.10.ebuild,v 1.2 2012/02/14 20:36:52 blueness Exp $

EAPI="4"

MY_PV="${PN}_${PV}-1ubuntu1_all"

DESCRIPTION="Bittorrent client that does not require a website to discover content"
HOMEPAGE="http://www.tribler.org/"
SRC_URI="http://dl.tribler.org/${MY_PV}.deb"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND=">=dev-lang/python-2.5[sqlite]
	>=dev-python/m2crypto-0.16
	>=dev-python/wxpython-2.8
	>=dev-python/apsw-3.6
	>=media-video/vlc-1.0.1
	>=dev-libs/openssl-0.9.8"

# Skipping for now:
# xulrunner-sdk >= 1.9.1.5 < 1.9.2 (optional, to run SwarmTransport)
# 7-Zip >= 4.6.5 (optional, to build SwarmTransport)

DEPEND="${RDEPEND}
	app-arch/unzip"

S=${WORKDIR}

src_unpack() {
	unpack ${A}
	unpack ./data.tar.gz
}

src_compile() { :; }

src_install() {
	#Rename the doc dir properly
	mv usr/share/doc/${PN} usr/share/doc/${P}

	#Move the readme to the doc dir
	mv usr/share/tribler/Tribler/readme.txt usr/share/doc/${P}

	#Remove the licenses scattered throughout
	rm usr/share/doc/${P}/copyright
	rm usr/share/tribler/Tribler/*.txt
	rm usr/share/tribler/Tribler/Core/DecentralizedTracking/pymdht/{LGPL-2.1.txt,LICENSE.txt}

	#Copy the rest over
	cp -pPR usr/ "${ED}"/
}
