# Copyright 1999-2002 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License, v2 or later
# $Header: /var/cvsroot/gentoo-x86/sys-apps/procps/procps-2.0.7-r6.ebuild,v 1.2 2002/07/06 15:37:57 drobbins Exp $

S=${WORKDIR}/${P}
DESCRIPTION="Standard informational utilities and process-handling tools"
SRC_URI="ftp://people.redhat.com/johnsonm/${PN}/${P}.tar.gz"
RDEPEND=">=sys-libs/ncurses-5.2-r2"
DEPEND="${RDEPEND} >=sys-devel/gettext-0.10.35"
LICENSE="GPL-2"
KEYWORDS="*"
SLOT="0"

src_unpack() {
	unpack ${A}

	cd ${S}

	# Patches from Red Hat SRPM 2.0.7-11
	# Didn't apply the -desktop and the -aix patches.

	patch -p1 < ${FILESDIR}/${PV}/${P}-locale.patch
	patch -p1 < ${FILESDIR}/${PV}/${P}-negvalue.patch
	patch -p1 < ${FILESDIR}/${PV}/${P}-retcode.patch
	patch -p1 < ${FILESDIR}/${PV}/${P}-biguid.patch
	patch -p1 < ${FILESDIR}/${PV}/${P}-bigbuff.patch
	patch -p1 < ${FILESDIR}/${PV}/${P}-sysctl-error.patch

	# Use the CFLAGS from /etc/make.conf.

	mv Makefile Makefile.orig
	sed -e "s/-O3/${CFLAGS}/" -e 's/all: config/all: /' \
	    -e "s:--strip::" Makefile.orig > Makefile

	cd ${S}/ps
	mv Makefile Makefile.orig
	sed -e "s/-O2/${CFLAGS}/" -e "s:--strip::" Makefile.orig > Makefile

	cd ${S}/proc
	mv Makefile Makefile.orig
	sed -e "s/-O2/${CFLAGS}/" -e "s:--strip::" Makefile.orig > Makefile
}

src_compile() {
	emake || die
}

src_install() {
	dodir /usr/bin
	dodir /sbin
	dodir /usr/X11R6/bin
	dodir /usr/share/man/man{1,5,8}
	dodir /lib
	dodir /bin

	make DESTDIR=${D} MANDIR=/usr/share/man install || die

	dodoc BUGS COPYING COPYING.LIB NEWS TODO
	docinto proc
	dodoc proc/COPYING
	docinto ps
	dodoc ps/COPYING ps/HACKING
}

