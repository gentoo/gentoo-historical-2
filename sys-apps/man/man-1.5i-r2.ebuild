# Copyright 1999-2002 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License, v2 or later
# $Header: /var/cvsroot/gentoo-x86/sys-apps/man/man-1.5i-r2.ebuild,v 1.2 2002/07/11 06:30:54 drobbins Exp $

NV=1.5i2
S=${WORKDIR}/${PN}-${NV}
DESCRIPTION="Standard commands to read man pages"
SRC_URI="http://www.kernel.org/pub/linux/utils/man/man-${NV}.tar.gz"

DEPEND="virtual/glibc"

RDEPEND="virtual/glibc
	sys-apps/groff"

src_unpack() {
	unpack ${A}
	cd ${S}
	cp configure configure.orig
	sed -e 's/confdir=.*$/confdir=\/etc/' \
		-e 's:/usr/lib/locale:$prefix/usr/lib/locale:g' \
		-e 's!/bin:/usr/bin:/usr/ucb:/usr/local/bin:$PATH!/bin:/usr/bin:/usr/local/bin:$PATH!' \
		configure.orig > configure
	local x
	for x in / src/ man2html/ msgs/
	do
		cd ${S}/${x}
		cp Makefile.in Makefile.in.orig
		sed -e '/inst.sh/d' \
			-e '/^CC =/c\' \
			-e "CC = gcc" \
			-e '/^CFLAGS =/c\' \
			-e "CFLAGS = $CFLAGS" \
			Makefile.in.orig > Makefile.in
	done
}

src_compile() {
	./configure +sgid +fhs +lang all || die
	#for FOOF in src man2html
	#do
	#	pmake ${FOOF}/Makefile MANCONFIG=/etc/man.conf || die
	#	cd ${S}/${FOOF}
	#	cp Makefile Makefile.orig
	#	sed -e "s/gcc -O/gcc ${CFLAGS}/" Makefile.orig > Makefile
	#	cd ${S}
	#done
	make || die
}

src_install() {
	dodir /usr/sbin /usr/bin
	cd ${S}
	make PREFIX=${D} install || die
	cd ${S}/msgs
	./inst.sh ?? ${D}/usr/share/locale/%L/%N
	chmod 2555 ${D}/usr/bin/man
	chown root.man ${D}/usr/bin/man
	insinto /etc
	doins ${FILESDIR}/man.conf
	cd ${S}
	dodoc COPYING LSM README* TODO
}


