# Copyright 1999-2003 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-admin/systemimager-common-bin/systemimager-common-bin-3.0.1.ebuild,v 1.2 2003/11/05 17:06:23 bass Exp $

MY_P="systemimager-common-3.0.1-4.noarch"

S=${WORKDIR}
DESCRIPTION="System imager common."
HOMEPAGE="http://www.systemimager.org/"
SRC_URI="mirror://sourceforge/systemimager/${MY_P}.rpm"

SLOT="0"
LICENSE="GPL-2"
KEYWORDS="x86"

DEPEND="app-arch/rpm2targz"
RDEPEND="${DEPEND}
		dev-perl/systemconfigurator"

src_unpack() {
	rpm2targz ${DISTDIR}/${MY_P}.rpm
	tar zxf ${WORKDIR}/${MY_P}.tar.gz
}

src_compile() {
	einfo "nothing to compile; binary package."
}

src_install() {
	dobin usr/bin/lsimage
	mkdir -p ${D}/usr/lib/systemimager/perl/SystemImager/
	insinto /usr/lib/systemimager/perl/SystemImager/
	doins usr/lib/systemimager/perl/SystemImager/{Common,Config}.pm
	doman usr/share/man/man5/autoinstallscript.conf.5.gz
	doman usr/share/man/man8/lsimage.8.gz

}

