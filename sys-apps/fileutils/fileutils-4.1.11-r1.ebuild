# Copyright 1999-2003 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sys-apps/fileutils/fileutils-4.1.11-r1.ebuild,v 1.5 2003/06/23 14:55:08 lostlogic Exp $

IUSE="acl nls build"
ACLPV=4.1.11acl-0.8.25

S=${WORKDIR}/${P}
DESCRIPTION="Standard GNU file utilities (chmod, cp, dd, dir, ls, etc)"
SRC_URI="ftp://alpha.gnu.org/gnu/fetish/${P}.tar.gz http://cvs.gentoo.org/~styx/fileutils-${ACLPV}.diff.gz"
HOMEPAGE="http://www.gnu.org/software/fileutils/fileutils.html"

KEYWORDS="x86 ~ppc ~sparc ~alpha ~hppa ~arm ~mips"
SLOT="0"
LICENSE="GPL-2"

DEPEND="virtual/glibc
	nls? ( sys-devel/gettext )"

RDEPEND="virtual/glibc"


src_unpack() {

	unpack ${A}

	if [ "`use acl`" ]; then 
		zcat ${DISTDIR}/fileutils-${ACLPV}.diff | patch -p0
		cd ${S}/lib
		cat ${FILESDIR}/acl.c.diff | patch -p0 -l || die
	fi
		
	cd ${S}
	# Fix braindead scripting problem in configure
	# <azarah@gentoo.org> (25 Sep 2002)
	patch -p1 < ${FILESDIR}/${P}-configure.patch || die
}

src_compile() {
	local myconf=""
	use nls || myconf="--disable-nls"
	
	./configure --prefix=/usr \
		--mandir=/usr/share/man \
		--infodir=/usr/share/info \
		--bindir=/bin \
		${myconf} || die
	
	emake || die
}

src_install() {
	make prefix=${D}/usr \
		mandir=${D}/usr/share/man \
		infodir=${D}/usr/share/info \
		bindir=${D}/bin \
		install || die
	
	cd ${D}
	dodir /usr/bin
	rm -rf usr/lib
	cd usr/bin
	ln -s ../../bin/* .
	
	if [ -z "`use build`" ]
	then
		cd ${S}
		dodoc AUTHORS ChangeLog* COPYING NEWS README* THANKS TODO

		#conflicts with textutils.  seems that they install the same
		#.info file between the two of them
		rm -f ${D}/usr/share/info/coreutils.info
	else
		rm -rf ${D}/usr/share
	fi
}

