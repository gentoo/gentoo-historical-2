# Copyright 1999-2001 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License, v2 or later
# $Header: /var/cvsroot/gentoo-x86/sys-apps/mosix-user/mosix-user-1.5.2-r1.ebuild,v 1.3 2002/07/11 06:30:54 drobbins Exp $

S=${WORKDIR}/user
DESCRIPTION="User-land utilities for MOSIX process migration (clustering) software"
SRC_URI="http://www.mosix.cs.huji.ac.il/ftps/MOSIX-${PV}.tar.gz"
HOMEPAGE="http://www.mosix.org"
DEPEND="virtual/glibc >=sys-libs/ncurses-5.2"

src_unpack() {
	mkdir ${S}; cd ${S}
	tar -xz --no-same-owner -f ${DISTDIR}/${A} MOSIX-${PV}/user.tar MOSIX-${PV}/manuals.tar	
	mv MOSIX-${PV}/*.tar .
	rm -rf MOSIX-${PV}
	tar -x --no-same-owner -f user.tar -C ${S}	
	tar -x --no-same-owner -f manuals.tar -C ${S}
}

src_compile() {
	cd ${S}
	local x
	for x in lib/moslib sbin/setpe sbin/tune bin/mosrun usr.bin/mon usr.bin/migrate usr.bin/mosctl
	do
		cd $x
		make || die
		cd ../..
	done
}

src_install () {
	cd ${S}
	make ROOT=${D} PREFIX=${D}/usr install
	dodir /usr/share	
	cd ${D}/usr
	mv man share	
	exeinto /etc/init.d
	newexe ${FILESDIR}/mosix.init mosix
	insinto /etc
	#stub mosix.map file
	doins ${FILESDIR}/mosix.map
	cd ${S}
	doman man?/*
}

pkg_postinst() {
	echo
	echo " To complete MOSIX installation, edit /etc/mosix.map and then type:
	echo "# rc-update add mosix default
	echo " ...to add MOSIX to the default runlevel.  This particular version of"
	echo " mosix-user has been designed to work with the 2.4.13 kernel."
	echo
}
