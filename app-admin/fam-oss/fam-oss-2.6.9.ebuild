# Copyright 1999-2002 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-admin/fam-oss/fam-oss-2.6.9.ebuild,v 1.6 2002/10/18 13:31:45 aliz Exp $

inherit libtool

MY_P=${P/-oss/}
S=${WORKDIR}/${MY_P}
DESCRIPTION="FAM, the File Alteration Monitor."
SRC_URI=ftp://oss.sgi.com/projects/fam/download/${MY_P}.tar.gz"
	ftp://oss.sgi.com/projects/fam/download/contrib/dnotify.patch"
HOMEPAGE="http://oss.sgi.com/projects/fam/"
KEYWORDS="x86 alpha"
SLOT="0"
IUSE=""
LICENSE="GPL-2 LGPL-2.1"
DEPEND=">=sys-devel/perl-5.6.1"

RDEPEND=">=net-nds/portmap-5b-r6"

src_unpack() {

	unpack ${MY_P}.tar.gz

	cd ${S}
	patch -p1 < ${DISTDIR}/dnotify.patch || die
	patch -p1 < ${FILESDIR}/${PF}-gcc3.patch || die

	cp ${FILESDIR}/${PF}-aclocal.m4 aclocal.m4
	elibtoolize
	aclocal
	autoconf
	autoheader
	automake --add-missing
}

src_install() {
	cp fam/fam.conf fam/fam.conf.old
	sed s:"local_only = false":"local_only = true":g fam/fam.conf.old >fam/fam.conf
			
	make DESTDIR=${D} \
		install || die
	     
	exeinto /etc/init.d
	doexe ${FILESDIR}/fam
	
	dodoc AUTHORS COPYING ChangeLog INSTALL NEWS TODO README*
}
