# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-dialup/hcfusbmodem/hcfusbmodem-1.10.ebuild,v 1.3 2006/09/22 19:14:00 mrness Exp $

inherit linux-info eutils

DESCRIPTION="hcfusbmodem - Modem driver for Connexant HSF chipset"
SRC_URI="http://www.linuxant.com/drivers/hcf/full/archive/${P}powerpcfull.tar.gz"
HOMEPAGE="http://www.linuxant.com/drivers/"

IUSE=""
SLOT="0"
LICENSE="Conexant"
KEYWORDS="~ppc"

DEPEND="dev-lang/perl
	app-arch/cpio"

S="${WORKDIR}/${P}powerpcfull"

QA_EXECSTACK="usr/lib/hcfusbmodem/modules/imported/hcfblam-powerpc.O usr/lib/hcfusbmodem/modules/imported/hcfengine-powerpc.O"

src_compile() {
	emake all || die "make failed"
}

src_install () {
	make PREFIX="${D}/usr/" ROOT="${D}" install || die "make install failed"
}

pkg_postinst() {
	einfo "To complete the installation and configuration of your HCF modem,"
	einfo "please run hcfusbconfig."
}
