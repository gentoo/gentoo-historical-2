# Copyright 1999-2002 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-admin/fam-oss/fam-oss-2.6.7-r1.ebuild,v 1.9 2002/10/04 03:40:38 vapier Exp $

inherit libtool

MY_P=${P/-oss/}
S=${WORKDIR}/${MY_P}
DESCRIPTION="FAM, the File Alteration Monitor."
SRC_URI=ftp://oss.sgi.com/projects/fam/download/${MY_P}.tar.gz""
HOMEPAGE="http://oss.sgi.com/projects/fam/"

SLOT="0"
LICENSE="GPL-2 LGPL-2.1"
KEYWORDS="x86 ppc sparc sparc64"

DEPEND=">=sys-devel/perl-5.6.1"
RDEPEND=">=net-nds/portmap-5b-r6"

src_unpack() {

	unpack ${A}

	cd ${S}
	# NOTE: dnotify patch for realtime updating, as well as build fixes
	patch -p1 < ${FILESDIR}/${PF}-gentoo.patch || die

	cp ${FILESDIR}/${PF}-aclocal.m4 aclocal.m4
	elibtoolize
	aclocal
	autoconf
	autoheader
	automake --add-missing
}

src_compile() {

	econf || die
	emake || die 
}

src_install() {

	make DESTDIR=${D} \
		install || die
		 
	exeinto /etc/init.d
	doexe ${FILESDIR}/fam
	
	dodoc AUTHORS COPYING ChangeLog INSTALL NEWS TODO README*
}
