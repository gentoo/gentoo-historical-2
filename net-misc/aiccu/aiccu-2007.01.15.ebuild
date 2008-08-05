# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-misc/aiccu/aiccu-2007.01.15.ebuild,v 1.8 2008/08/05 11:09:29 gmsoft Exp $

inherit eutils

DESCRIPTION="AICCU Client to configure an IPv6 tunnel to SixXS"
HOMEPAGE="http://www.sixxs.net/tools/aiccu"
SRC_URI="http://www.sixxs.net/archive/sixxs/aiccu/unix/${PN}_${PV//\./}.tar.gz"

LICENSE="SixXS"
SLOT="0"
KEYWORDS="amd64 arm hppa ~ppc ~sparc x86"
IUSE=""
DEPEND="net-libs/gnutls
		sys-apps/iproute2"
S=${WORKDIR}/aiccu

src_unpack() {
	unpack ${A}
	cd "${S}"

	epatch "${FILESDIR}/${P}-as-needed.patch"
}

src_compile() {
	cd ${S}
	export RPM_OPT_FLAGS=${CFLAGS}
	make  || die "Build Failed"
}

src_install() {
	dosbin unix-console/aiccu
	insopts -m 600
	insinto /etc
	doins doc/aiccu.conf
	dodoc doc/{HOWTO,LICENSE,README,changelog}
	newinitd doc/aiccu.init.gentoo aiccu
}

pkg_postinst() {
	einfo "The aiccu ebuild installs an init script named 'aiccu'"
	einfo "To add support for a SixXS connection at startup, do"
	einfo "edit your /etc/aiccu.conf and do"
	einfo "# rc-update add aiccu default"
}
