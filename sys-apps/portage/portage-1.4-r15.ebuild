# Copyright 1999-2000 Gentoo Technologies, Inc. Distributed under the terms
# of the GNU General Public License, v2 or later 
# Author Daniel Robbins <drobbins@gentoo.org>
# $Header: /var/cvsroot/gentoo-x86/sys-apps/portage/portage-1.4-r15.ebuild,v 1.1 2001/02/07 15:51:28 achim Exp $
 
A=""
S=${WORKDIR}/${P}
DESCRIPTION="Portage autobuild system"
SRC_URI=""
HOMEPAGE="http://www.gentoo.org"

RDEPEND="sys-devel/perl"

src_unpack() {
  mkdir ${S}
}

src_compile() {                           
  cd ${S}
}

src_install() {

	cd ${FILESDIR}
	insinto /etc
	doins make.defaults
	newins make.conf make.conf.eg
	dodir /usr/lib/portage/bin
	dodir /usr/bin
	dodir /usr/sbin
	insinto /usr/bin
	insopts -m755
	doins newbin/ebuild *.sh
	insinto /usr/sbin
	doins portage-merge portage-unmerge pkgname
	insinto /usr/lib/python2.0
	doins portage.py
	exeinto /usr/lib/portage/bin
	doexe bin/* mega* portage-maintain
        doexe newbin/*
        rm ${D}/usr/lib/portage/bin/ebuild
	dosym /usr/lib/portage/bin/pkgmerge /usr/sbin/pkgmerge
	dosym /usr/lib/portage/bin/portage-maintain /usr/sbin/portage-maintain
	dosym newins /usr/lib/portage/bin/donewins
	exeinto /usr/sbin
	doexe env-update
	doman man/*.[15]

}

pkg_postinst() {
	if [ ! -e ${ROOT}/etc/make.conf ]
	then
		cp ${ROOT}/etc/make.conf.eg ${ROOT}/etc/make.conf
	fi
}


