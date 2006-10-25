# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sys-kernel/genkernel/genkernel-3.4.4.ebuild,v 1.1 2006/10/25 22:56:37 wolf31o2 Exp $

inherit eutils

VERSION_DMAP='1.00.17'
VERSION_DMRAID='1.0.0.rc10'
VERSION_E2FSPROGS='1.38'
VERSION_LVM2='2.00.25'
VERSION_PKG='3.4'
VERSION_UNIONFS='1.1.4'

DESCRIPTION="Gentoo autokernel script"
HOMEPAGE="http://www.gentoo.org"
SRC_URI="http://dev.gentoo.org/~wolf31o2/sources/genkernel/${P}.tar.bz2
	http://dev.gentoo.org/~wolf31o2/sources/genkernel/genkernel-pkg-${VERSION_PKG}.tar.bz2
	http://people.redhat.com/~heinzm/sw/dmraid/src/dmraid-${VERSION_DMRAID}.tar.bz2
	ftp://sources.redhat.com/pub/lvm2/old/LVM2.${VERSION_LVM2}.tgz
	ftp://sources.redhat.com/pub/dm/old/device-mapper.${VERSION_DMAP}.tgz
	ftp://ftp.fsl.cs.sunysb.edu/pub/unionfs/unionfs-${VERSION_UNIONFS}.tar.gz
	mirror://sourceforge/e2fsprogs/e2fsprogs-${VERSION_E2FSPROGS}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~hppa ~ia64 ~mips ~ppc ~ppc64 ~s390 ~sparc ~x86"
#KEYWORDS="alpha amd64 arm hppa ia64 mips ppc ppc64 s390 sparc x86"
IUSE="ibm"

DEPEND="sys-fs/e2fsprogs"

src_unpack() {
	unpack ${P}.tar.bz2
	cd "${S}"
	unpack ${PN}-pkg-${VERSION_PKG}.tar.bz2
}

src_install() {
	dodir /etc
	cp "${S}"/genkernel.conf ${D}/etc
	# This block updates genkernel.conf
	sed -i -e "s:VERSION_DMAP:$VERSION_DMAP:" \
		-e "s:VERSION_DMRAID:$VERSION_DMRAID:" \
		-e "s:VERSION_E2FSPROGS:$VERSION_E2FSPROGS:" \
		-e "s:VERSION_LVM2:$VERSION_LVM2:" \
		-e "s:VERSION_UNIONFS:$VERSION_UNIONFS:" \
		${D}/etc/genkernel.conf || die "Could not adjust versions"

	dodir /usr/share/genkernel
	use ibm && cp "${S}"/ppc64/kernel-2.6-pSeries "${S}"/ppc64/kernel-2.6 || \
		cp "${S}"/ppc64/kernel-2.6.g5 "${S}"/ppc64/kernel-2.6
	cp -Rp "${S}"/* ${D}/usr/share/genkernel

	dodir /usr/bin
	dosym /usr/share/genkernel/genkernel /usr/bin/genkernel

	rm ${D}/usr/share/genkernel/genkernel.conf
	dodoc README

	doman genkernel.8
	rm genkernel.8

	cp "${DISTDIR}"/dmraid-${VERSION_DMRAID}.tar.bz2 \
	"${DISTDIR}"/LVM2.${VERSION_LVM2}.tgz \
	"${DISTDIR}"/device-mapper.${VERSION_DMAP}.tgz \
	"${DISTDIR}"/unionfs-${VERSION_UNIONFS}.tar.gz \
	"${DISTDIR}"/e2fsprogs-${VERSION_E2FSPROGS}.tar.gz \
	${D}/usr/share/genkernel/pkg
}

pkg_postinst() {
	echo
	elog 'Documentation is available in the genkernel manual page'
	elog 'as well as the following URL:'
	echo
	elog 'http://www.gentoo.org/doc/en/genkernel.xml'
	echo
	ewarn "This package is known to not work with reiser4.  If you are running"
	ewarn "reiser4 and have a problem, do not file a bug.  We know it does not"
	ewarn "work and we don't plan on fixing it since reiser4 is the one that is"
	ewarn "broken in this regard.  Try using a sane filesystem like ext3 or"
	ewarn "even reiser3."
	echo
}
