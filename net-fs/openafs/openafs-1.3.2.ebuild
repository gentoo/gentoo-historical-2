# Copyright 1999-2002 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License, v2 or later
# /home/cvsroot/gentoo-x86/net-fs/openafs/openafs-1.1.1.ebuild,v 1.3 2001/08/31 03:23:39 pm Exp


S=${WORKDIR}/${P}
DESCRIPTION="The AFS 3 distributed file system  targets the issues  critical to
distributed computing environments. AFS performs exceptionally well,
both within small, local work groups of machines and across wide-area
configurations in support of large, collaborative efforts. AFS provides
an architecture geared towards system management, along with the tools
to perform important management tasks. For a user, AFS is a familiar yet
extensive UNIX environment for accessing files easily and quickly."

SRC_URI="http://www.openafs.org/dl/openafs/${PV}/openafs-${PV}-src.tar.gz"
HOMEPAGE="http://www.openafs.org/"

SLOT="0"
LICENSE="IPL-1"
KEYWORDS="x86 -ppc -sparc -sparc64"

DEPEND=">=sys-libs/ncurses-5.2
	>=sys-libs/pam-0.75"

ARCH=i386_linux24

src_unpack() {
	unpack ${A}

	cd ${S}/src/config
	cp Makefile.in Makefile.in.old
	sed -e "s|/usr/lib/libncurses.so|-lncurses|g" \
		Makefile.in.old > Makefile.in
	rm Makefile.in.old
}

src_compile() {
	./configure \
		--with-afs-sysname=i386_linux24 \
		--enable-transarc-paths || die
	make || die
	make dest || die
}

src_install () {


  # Client

	cd ${S}/${ARCH}/dest/root.client/usr/vice
	
	insinto /etc/afs/modload
	doins etc/modload/*
	insinto /etc/afs/C
	doins etc/C/*

	insinto /etc/afs
	doins ${FILESDIR}/{ThisCell,CellServDB}
	doins etc/afs.conf

	dodir /afs

	exeinto /etc/init.d
	newexe ${FILESDIR}/afs.rc.rc6 afs

	dosbin etc/afsd

	# Client Bin
	cd ${S}/${ARCH}/dest
	exeinto /usr/afsws/bin
	doexe bin/*

	exeinto /etc/afs/afsws
	doexe etc/*

	cp -a include lib ${D}/usr/afsws
	dosym  /usr/afsws/lib/afs/libtermlib.a /usr/afsws/lib/afs/libnull.a

	# Server
	cd ${S}/${ARCH}/dest/root.server/usr/afs
	exeinto /usr/afs/bin
	doexe bin/*

	dodir /usr/vice
	dosym /etc/afs /usr/vice/etc
	dosym /etc/afs/afsws /usr/afsws/etc

	dodoc ${FILESDIR}/README

	dodir /etc/env.d
	echo "CONFIG_PROTECT_MASK=\"/etc/afs\"" >> ${D}/etc/env.d/01${PN}
}

pkg_postinst () {
	echo ">>> UPDATE CellServDB and ThisCell to your needs !!"
	echo ">>> FOLLOW THE INSTRUCTIONS IN AFS QUICK BEGINNINGS"
	echo ">>> PAGE >45 TO DO INITIAL SERVER SETUP"    fi
}
