# Copyright 1999-2004 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-dialup/hcfusbmodem/hcfusbmodem-0.99.03042703.ebuild,v 1.2 2004/06/24 22:27:45 agriffis Exp $

MY_PV=0.99lnxtbeta03042703ppc
MY_P=${PN}-${MY_PV}
S=${WORKDIR}/${MY_P}
DESCRIPTION="hcfusbmodem - Modem driver for Connexant HSF chipset"
SRC_URI="http://www.linuxant.com/drivers/hcf/archive/${MY_P}/${MY_P}.tar.gz"
HOMEPAGE="http://www.linuxant.com/drivers"
DEPEND="virtual/glibc"
IUSE=""
SLOT="0"
LICENSE="Conexant"
KEYWORDS="~ppc"

src_compile() {
	emake all || die
}

src_install () {
	make PREFIX=${D}/usr/ ROOT=${D} install || die
}

pkg_postinst() {
	echo "To complete the installation and configuration of your HCF modem,"
	echo "please run hcfusbconfig."
}
