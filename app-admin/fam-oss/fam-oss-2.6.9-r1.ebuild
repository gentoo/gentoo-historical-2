# Copyright 1999-2002 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-admin/fam-oss/fam-oss-2.6.9-r1.ebuild,v 1.6 2003/02/10 17:22:54 foser Exp $

IUSE=""

inherit libtool eutils

MY_P="${P/-oss/}"
S="${WORKDIR}/${MY_P}"
DESCRIPTION="FAM, the File Alteration Monitor."
SRC_URI="ftp://oss.sgi.com/projects/fam/download/${MY_P}.tar.gz"

HOMEPAGE="http://oss.sgi.com/projects/fam/"

KEYWORDS="x86 ~ppc ~alpha ~sparc"
SLOT="0"
LICENSE="GPL-2 LGPL-2.1"

DEPEND=">=sys-devel/perl-5.6.1"
RDEPEND=">=net-nds/portmap-5b-r6"

src_unpack() {
	unpack ${MY_P}.tar.gz

	cd ${S}
	epatch ${DISTDIR}/dnotify.patch || die
	epatch ${FILESDIR}/${P}-gcc3.patch || die

	# should fix the sigqueue overflow problems
	cd ${S}/fam
	mv Makefile.am Makefile.am.old
	sed -e "s:fam_LDADD =:fam_LDADD = -lrt -lpthread:" Makefile.am.old > Makefile.am

	elibtoolize
	
	export WANT_AUTOCONF_2_5=1
	export WANT_AUTOMAKE_1_5=1
	automake --add-missing
	aclocal
	autoconf
	autoheader
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
