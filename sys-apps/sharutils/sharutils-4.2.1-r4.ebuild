# Copyright 1999-2000 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License, v2 or later
# Author Daniel Robbins <drobbins@gentoo.org>
# $Header: /var/cvsroot/gentoo-x86/sys-apps/sharutils/sharutils-4.2.1-r4.ebuild,v 1.2 2001/08/23 15:57:34 drobbins Exp $

A=${P}.tar.gz
S=${WORKDIR}/${P}
DESCRIPTION="Tools to deal with shar archives"
SRC_URI="ftp://gatekeeper.dec.com/pub/GNU/sharutils/${A}
	 ftp://prep.ai.mit.edu/gnu/sharutils/${A}"

DEPEND="virtual/glibc sys-apps/texinfo >=sys-devel/gettext-0.10.35"
RDEPEND="virtual/glibc"


src_unpack() {

     unpack ${A}
     cd ${WORKDIR}
     patch -p0 < ${FILESDIR}/${PF}-gentoo.diff
     cd ${S}/po
     mv nl.po nl.po.orig
     sed -e 's/aangemaakt/aangemaakt\\n/' nl.po.orig > nl.po
     mv pt.po pt.po.orig
     sed -e 's/de %dk/de %dk\\n/' pt.po.orig > pt.po

}

src_compile() {

	try ./configure --host=${CHOST} --prefix=/usr
	try make ${MAKEOPTS} localedir=/usr/share/locale
}

src_install() {

	try make prefix=${D}/usr localedir=${D}/usr/share/locale infodir=${D}/usr/share/info install

	doman doc/*.[15]
        #Remove some strange locals
        cd ${D}/usr/share/locale
        for i in *.
        do
           rm -rf ${i}
        done
	rm -rf ${D}/usr/lib

	cd ${S}
	dodoc AUTHORS BACKLOG COPYING ChangeLog ChangeLog.OLD \
	      NEWS README README.OLD THANKS TODO
}


