# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sys-kernel/genkernel/genkernel-3.2.0_pre12.ebuild,v 1.1 2005/06/24 17:23:25 plasmaroo Exp $

VERSION_DMAP='1.00.17'
VERSION_DMRAID='1.0.0.rc6'
VERSION_LVM2='2.00.25'
VERSION_UNIONFS='1.0.12a'

DESCRIPTION="Gentoo autokernel script"
HOMEPAGE="http://www.gentoo.org"
SRC_URI="http://dev.gentoo.org/~plasmaroo/patches/kernel/genkernel/${P}.tar.bz2
	 http://people.redhat.com/~heinzm/sw/dmraid/src/dmraid-${VERSION_DMRAID}.tar.bz2
	 ftp://sources.redhat.com/pub/lvm2/old/LVM2.${VERSION_LVM2}.tgz
	 ftp://sources.redhat.com/pub/dm/old/device-mapper.${VERSION_DMAP}.tgz
	 ftp://ftp.fsl.cs.sunysb.edu/pub/unionfs/unionfs-${VERSION_UNIONFS}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="x86 ppc sparc mips alpha arm hppa amd64 ia64 s390 ppc64"
IUSE="bootsplash ibm"

DEPEND="sys-fs/e2fsprogs
	x86? ( bootsplash? ( media-gfx/bootsplash ) )
	amd64? ( bootsplash? ( media-gfx/bootsplash ) )"

src_unpack() {
	unpack ${P}.tar.bz2
}

src_install() {
	dodir /etc
	cp ${S}/genkernel.conf ${D}/etc

	dodir /usr/share/genkernel
	use ibm && cp ${S}/ppc64/kernel-2.6-pSeries ${S}/ppc64/kernel-2.6 || cp ${S}/ppc64/kernel-2.6.g5 ${S}/ppc64/kernel-2.6
	cp -Rp ${S}/* ${D}/usr/share/genkernel

	dodir /usr/bin
	dosym /usr/share/genkernel/genkernel /usr/bin/genkernel

	rm ${D}/usr/share/genkernel/genkernel.conf
	dodoc README

	doman genkernel.8
	rm genkernel.8

	cp ${DISTDIR}/dmraid-${VERSION_DMRAID}.tar.bz2 ${DISTDIR}/LVM2.${VERSION_LVM2}.tgz ${DISTDIR}/device-mapper.${VERSION_DMAP}.tgz ${DISTDIR}/unionfs-${VERSION_UNIONFS}.tar.gz ${D}/usr/share/genkernel/pkg
}

pkg_postinst() {
	echo
	einfo 'Documentation is available in the genkernel manual page'
	einfo 'as well as the following URL:'
	echo
	einfo 'http://www.gentoo.org/doc/en/genkernel.xml'
	echo
}
