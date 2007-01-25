# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sys-apps/855resolution/855resolution-0.4.ebuild,v 1.2 2007/01/25 04:30:25 beandog Exp $

S="${WORKDIR}/${PN}"

DESCRIPTION="Utility to patch VBIOS of Intel 855 / 865 / 915 chipsets."
HOMEPAGE="http://perso.wanadoo.fr/apoirier"
SRC_URI="http://perso.wanadoo.fr/apoirier/${P}.tgz"
RESTRICT="strip"
LICENSE="public-domain as-is"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND="virtual/libc"

src_compile() {
	emake || die "emake failed"
}

src_install() {
	exeinto /usr/sbin
	doexe ${PN}

	dodoc README.txt

	insinto /etc/conf.d
	newins ${FILESDIR}/${PV}/conf 855resolution
	exeinto /etc/init.d
	newexe ${FILESDIR}/${PV}/init 855resolution
}
