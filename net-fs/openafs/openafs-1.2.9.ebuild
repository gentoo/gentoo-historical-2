# Copyright 1999-2003 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-fs/openafs/openafs-1.2.9.ebuild,v 1.6 2003/11/21 18:16:46 rphillips Exp $

inherit check-kernel

S=${WORKDIR}/${P}
DESCRIPTION="The AFS 3 distributed file system  targets the issues  critical to
distributed computing environments."
HOMEPAGE="http://www.openafs.org/"
SRC_URI="http://openafs.org/dl/openafs/${PV}/${P}-src.tar.bz2"

SLOT="0"
LICENSE="IPL-1"
KEYWORDS="-* ~x86"

SANDBOX_DISABLED="1"

DEPEND="virtual/linux-sources
	>=sys-apps/sed-4
	>=sys-apps/portage-2.0.47-r10
	>=sys-libs/ncurses-5.2
	>=sys-libs/pam-0.75"

SYS_NAME=i386_linux24


pkg_setup() {

	if is_2_5_kernel || is_2_6_kernel
	then
		die "This only works with 2.4 kernels"
	fi
}


src_unpack() {
	unpack ${A}

	cd ${S}/src/config
	sed -i "s|/usr/lib/libncurses.so|-lncurses|g" Makefile.i386_linux24.in

	cd ${S}
	epatch ${FILESDIR}/openafs-pinstall-execve.patch
}

src_compile() {

	econf \
		--with-afs-sysname=i386_linux24 \
		--enable-transarc-paths || die

	sed -i "s|-I/usr/include/sys| |g" src/pam/Makefile

	make || die
	make dest || die
}

src_install () {
	# Client

	cd ${S}/${SYS_NAME}/dest/root.client/usr/vice

	insinto /etc/afs/modload
	doins etc/modload/*
	insinto /etc/afs/C
	doins etc/C/*

	insinto /etc/afs
	doins ${FILESDIR}/{ThisCell,CellServDB}
	doins etc/afs.conf

	keepdir /afs

	exeinto /etc/init.d
	newexe ${FILESDIR}/afs.rc.rc6 afs

	dosbin etc/afsd

	# Client Bin
	cd ${S}/${SYS_NAME}/dest
	exeinto /usr/afsws/bin
	doexe bin/*

	exeinto /etc/afs/afsws
	doexe etc/*

	cp -a include lib ${D}/usr/afsws
	dosym  /usr/afsws/lib/afs/libtermlib.a /usr/afsws/lib/afs/libnull.a

	# Server
	cd ${S}/${SYS_NAME}/dest/root.server/usr/afs
	exeinto /usr/afs/bin
	doexe bin/*

	dodir /usr/vice
	dosym /etc/afs /usr/vice/etc
	dosym /etc/afs/afsws /usr/afsws/etc

	dodoc ${FILESDIR}/README

	dodir /etc/env.d
	echo 'CONFIG_PROTECT_MASK="/etc/afs/C /etc/afs/afsws"' \
		>> ${D}/etc/env.d/01${PN}
	echo 'PATH=/usr/afsws/bin:/etc/afs/afsws' \
		>> ${D}/etc/env.d/01${PN}
	echo 'ROOTPATH=/usr/afsws/bin:/etc/afs/afsws:/usr/afs/bin' \
		>> ${D}/etc/env.d/01${PN}
}

pkg_postinst () {
	einfo "UPDATE CellServDB and ThisCell to your needs !!"
	einfo "FOLLOW THE INSTRUCTIONS IN AFS QUICK BEGINNINGS"
	einfo "PAGE >45 TO DO INITIAL SERVER SETUP"
}
