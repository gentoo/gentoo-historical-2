# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-irc/xchat-otr/xchat-otr-0.3.ebuild,v 1.1 2010/06/28 08:34:16 polynomial-c Exp $

inherit cmake-utils eutils

DESCRIPTION="Off-The-Record messaging (OTR) for xchat"
HOMEPAGE="http://irssi-otr.tuxfamily.org"

# This should probably be exported by cmake-utils as a variable
CMAKE_BINARY_DIR="${WORKDIR}"/${PN}_build
mycmakeargs="-DDOCDIR=/usr/share/doc/${PF}"

SRC_URI="ftp://download.tuxfamily.org/irssiotr/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64"
IUSE="debug"

RDEPEND="net-libs/libotr
	net-irc/xchat
	dev-libs/glib
	dev-libs/libgcrypt
	dev-libs/libgpg-error"

DEPEND="${RDEPEND}
	>=dev-util/cmake-2.4.7
	dev-util/pkgconfig
	dev-lang/python"

src_install() {
	cmake-utils_src_install
	rm "${D}"/usr/share/doc/${PF}/LICENSE
	prepalldocs
}
