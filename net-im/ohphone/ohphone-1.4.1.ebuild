# Copyright 1999-2004 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-im/ohphone/ohphone-1.4.1.ebuild,v 1.3 2004/06/24 22:58:24 agriffis Exp $

DESCRIPTION="Command line H.323 client"
HOMEPAGE="http://www.openh323.org/"
SRC_URI="http://www.openh323.org/bin/${PN}_${PV}.tar.gz"

LICENSE="MPL-1.0"
SLOT="0"
KEYWORDS="~x86"
IUSE=""

DEPEND=">=net-libs/openh323-1.12
	>=dev-libs/pwlib-1.5.0"

src_compile() {
	cd ${WORKDIR}/${PN}
	emake \
		OPENH323DIR=/usr/share/openh323 \
		PREFIX=/usr \
		PWLIBDIR=/usr/share/pwlib \
		PW_LIBDIR=/usr/lib \
		OH323_LIBDIR=/usr/lib \
		opt man || die
}

src_install() {
	cd ${WORKDIR}/${PN}
	doman ohphone.1

	# fill in for other archs
	if [ ${ARCH} = "x86" ]; then
		dobin obj_linux_x86_r/ohphone
	fi
}
