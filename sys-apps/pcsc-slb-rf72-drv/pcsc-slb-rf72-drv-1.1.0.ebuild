# Copyright 1999-2002 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sys-apps/pcsc-slb-rf72-drv/pcsc-slb-rf72-drv-1.1.0.ebuild,v 1.1 2002/11/16 23:24:09 zwelch Exp $

MY_P="slb_rf72"
S=${WORKDIR}/${MY_P}
DESCRIPTION="Schlumberger Reflex 72 Serial Smartcard Reader"
HOMEPAGE="http://www.linuxnet.com/sourcedrivers.html"
LICENSE="as-is"
KEYWORDS="~x86"
SLOT="0"
SRC_URI="http://www.linuxnet.com/drivers/readers/files/slb_rf72-drv-1.1.0.tar.gz"
DEPEND=">=sys-devel/gcc-2.95.3-r5
	sys-apps/pcsc-lite"

src_compile() {
	emake || die
}

src_install () {

	insinto /usr/share/doc/${MY_P} 
	doins doc/*.html doc/*.gif ERRATA LICENSE README
	
	insinto /usr/share/doc/${MY_P}/sample 
	doins sample/*
	
	insinto /usr/lib/readers
	insopts -m755
	doins *.so

}
