# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sys-kernel/genkernel/genkernel-3.3.11_pre5.ebuild,v 1.1 2006/01/25 21:10:55 wolf31o2 Exp $

VERSION_DMAP='1.00.17'
VERSION_DMRAID='1.0.0.rc9'
VERSION_E2FSPROGS='1.38'
VERSION_LVM2='2.00.25'
VERSION_PKG='3.3.9'
VERSION_UNIONFS='1.1.1'
VERSION_UDEV="077"
VERSION_KLIBC="1.1.16"

DESCRIPTION="Gentoo autokernel script"
HOMEPAGE="http://www.gentoo.org"
SRC_URI="http://dev.gentoo.org/~wolf31o2/${P}.tar.bz2
	http://dev.gentoo.org/~plasmaroo/patches/kernel/genkernel/genkernel-pkg-${VERSION_PKG}.tar.bz2
	http://people.redhat.com/~heinzm/sw/dmraid/src/dmraid-${VERSION_DMRAID}.tar.bz2
	ftp://sources.redhat.com/pub/lvm2/old/LVM2.${VERSION_LVM2}.tgz
	ftp://sources.redhat.com/pub/dm/old/device-mapper.${VERSION_DMAP}.tgz
	ftp://ftp.fsl.cs.sunysb.edu/pub/unionfs/unionfs-${VERSION_UNIONFS}.tar.gz
	mirror://sourceforge/e2fsprogs/e2fsprogs-${VERSION_E2FSPROGS}.tar.gz
	mirror://kernel/linux/utils/kernel/hotplug/udev-${VERSION_UDEV}.tar.bz2
	http://www.kernel.org/pub/linux/libs/klibc/Testing/klibc-${VERSION_KLIBC}.tar.gz
	http://dev.gentoo.org/~wolf31o2/sources/dump/klibc-1.1.16-sparc2.patch
	mirror://gentoo//klibc-1.1.16-sparc2.patch"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~hppa ~ia64 ~mips ~ppc ~ppc64 ~s390 ~sparc ~x86"
#KEYWORDS="alpha amd64 arm hppa ia64 mips ppc ppc64 s390 sparc x86"
IUSE="bootsplash ibm"

DEPEND="sys-fs/e2fsprogs
	x86? ( bootsplash? ( media-gfx/bootsplash ) )
	amd64? ( bootsplash? ( media-gfx/bootsplash ) )"

src_unpack() {
	unpack ${P}.tar.bz2
	cd ${S}
	unpack ${PN}-pkg-${VERSION_PKG}.tar.bz2
}

src_install() {
	dodir /etc
	cp ${S}/genkernel.conf ${D}/etc
	# This block updates genkernel.conf
	sed -i -e "s:VERSION_DMAP:$VERSION_DMAP:" \
		-e "s:VERSION_DMRAID:$VERSION_DMRAID:" \
		-e "s:VERSION_E2FSPROGS:$VERSION_E2FSPROGS:" \
		-e "s:VERSION_LVM2:$VERSION_LVM2:" \
		-e "s:VERSION_UNIONFS:$VERSION_UNIONFS:" \
		-e "s:VERSION_UDEV:$VERSION_UDEV:" \
		-e "s:VERSION_KLIBC:$VERSION_KLIBC:" \
		${D}/etc/genkernel.conf || die "Could not adjust versions"

	dodir /usr/share/genkernel
	use ibm && cp ${S}/ppc64/kernel-2.6-pSeries ${S}/ppc64/kernel-2.6 || cp ${S}/ppc64/kernel-2.6.g5 ${S}/ppc64/kernel-2.6
	cp -Rp ${S}/* ${D}/usr/share/genkernel

	dodir /usr/bin
	dosym /usr/share/genkernel/genkernel /usr/bin/genkernel

	rm ${D}/usr/share/genkernel/genkernel.conf
	dodoc README

	doman genkernel.8
	rm genkernel.8

	cp ${DISTDIR}/dmraid-${VERSION_DMRAID}.tar.bz2 \
	${DISTDIR}/LVM2.${VERSION_LVM2}.tgz \
	${DISTDIR}/device-mapper.${VERSION_DMAP}.tgz \
	${DISTDIR}/unionfs-${VERSION_UNIONFS}.tar.gz \
	${DISTDIR}/e2fsprogs-${VERSION_E2FSPROGS}.tar.gz \
	${DISTDIR}/klibc-${VERSION_KLIBC}.tar.gz \
	${DISTDIR}/udev-${VERSION_UDEV}.tar.bz2 \
	${DISTDIR}/klibc-1.1.16-sparc2.patch \
	${D}/usr/share/genkernel/pkg
}

pkg_postinst() {
	echo
	einfo 'Documentation is available in the genkernel manual page'
	einfo 'as well as the following URL:'
	echo
	einfo 'http://www.gentoo.org/doc/en/genkernel.xml'
	echo
}
