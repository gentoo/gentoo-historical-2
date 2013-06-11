# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-wireless/hackrf-tools/hackrf-tools-2013.06.1.ebuild,v 1.1 2013/06/11 03:06:20 zerochaos Exp $

EAPI=5

inherit cmake-utils

DESCRIPTION="library for communicating with HackRF SDR platform"
HOMEPAGE="http://greatscottgadgets.com/hackrf/"

if [[ ${PV} == "9999" ]] ; then
	EGIT_REPO_URI="https://github.com/mossmann/hackrf.git"
	inherit git-2
	KEYWORDS=""
	EGIT_SOURCEDIR="${WORKDIR}/hackrf"
	S="${WORKDIR}/hackrf/host/hackrf-tools"
else
	S="${WORKDIR}/hackrf-${PV}/host/hackrf-tools"
	SRC_URI="mirror://sourceforge/hackrf/hackrf-${PV}.tar.xz"
	KEYWORDS="~amd64 ~arm ~ppc ~x86"
fi

LICENSE="BSD"
SLOT="0"
IUSE=""

DEPEND="virtual/libusb:1
	net-libs/libhackrf:="
RDEPEND="${DEPEND}"
