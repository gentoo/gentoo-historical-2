# Copyright 1999-2004 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-dialup/hcfpcimodem/hcfpcimodem-0.99.02123100.ebuild,v 1.5 2004/06/24 22:27:33 agriffis Exp $

MY_PV=0.99mbsibeta02123100
MY_P=${PN}-${MY_PV}
S=${WORKDIR}/${MY_P}
DESCRIPTION="hcfpcimodem - Modem driver for Connexant HSF chipset"
SRC_URI="http://www.mbsi.ca/cnxtlindrv/hcf/archive/${MY_P}/${MY_P}.tar.gz"
HOMEPAGE="http://www.mbsi.ca/cnxtlindrv/"
DEPEND="virtual/glibc"
IUSE=""
SLOT="0"
LICENSE="Conexant"
KEYWORDS="x86"

src_compile() {
	emake all || die
}

src_install () {
	make PREFIX=${D}/usr/ ROOT=${D} install || die
}

pkg_postinst() {
	echo "To complete the installation and configuration of your HCF modem,"
	echo "please run hcfpciconfig."
}
