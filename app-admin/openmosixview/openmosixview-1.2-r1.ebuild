# Copyright 1999-2003 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-admin/openmosixview/openmosixview-1.2-r1.ebuild,v 1.4 2003/02/13 05:28:08 vapier Exp $

S=${WORKDIR}/openmosixview
DESCRIPTION="cluster-management GUI for OpenMosix"
SRC_URI="www.openmosixview.com/download/openmosixview-${PV}.tar.gz www.openmosixview.com/download/openmosixview-${PV}.patchforgcc3.gz"
HOMEPAGE="http://www.openmosixview.com"
IUSE=""

DEPEND=">=x11-libs/qt-2.3.0
	>=sys-cluster/openmosix-user-0.2.4
	>=sys-kernel/openmosix-sources-2.4.18"

SLOT="0"
LICENSE="GPL-2"
KEYWORDS="x86 -ppc -sparc  -alpha"

src_unpack() {
	cd ${WORKDIR}
	unpack openmosixview-${PV}.tar.gz
	cat ${DISTDIR}/${P}.patchforgcc3.gz | gunzip -c | patch -p0 || die
	
	
	cat > configuration << EOF

	# test which version of qt is installed
	if [ -d /usr/qt/3 ]; then
		QTDIR=/usr/qt/3; else
		QTDIR=/usr/qt/2;
	fi

	CC=gcc
EOF
}

src_compile() {
	cd ${S}
	autoconf || die
	./configure || die
	make || die

	cd ${S}/openmosixcollector
	autoconf || die
	./configure || die
	make || die
	
	cd ${S}/openmosixanalyzer
	autoconf || die
	./configure || die
	make || die
	
	cd ${S}/openmosixhistory
	autoconf || die
	./configure || die
	make || die
	
	cd ${S}/openmosixprocs
	autoconf || die
	./configure || die
	make || die
}

src_install() {
	dodir /usr/sbin
	dodir /usr/local/bin

	make INSTALLBASEDIR=${D}usr INSTALLMANDIR=${D}usr/share/man DESTDIR=${D} INSTALLDIR=${D}usr install || die
	cd ${S}/openmosixcollector
	make INSTALLBASEDIR=${D}usr INSTALLMANDIR=${D}usr/share/man DESTDIR=${D} INSTALLDIR=${D}usr install || die
	cd ${S}/openmosixanalyzer
	make INSTALLBASEDIR=${D}usr INSTALLMANDIR=${D}usr/share/man DESTDIR=${D} INSTALLDIR=${D}usr install || die
	cd ${S}/openmosixhistory
	make INSTALLBASEDIR=${D}usr INSTALLMANDIR=${D}usr/share/man DESTDIR=${D} INSTALLDIR=${D}usr install || die
	cd ${S}/openmosixprocs
	make INSTALLBASEDIR=${D}usr INSTALLMANDIR=${D}usr/share/man DESTDIR=${D} INSTALLDIR=${D}usr install || die

	dodoc COPYING README

	exeinto /etc/init.d
	newexe ${S}/openmosixcollector/openmosixcollector.init openmosixcollector
}

pkg_postinst() {
	einfo
	einfo "Openmosixview will allow you to monitor all nodes in your cluster."
	einfo
	einfo "You will need ssh to all cluster-nodes without password."
	einfo
	einfo "To setup your other nodes you will have to copy the"
	einfo "openmosixprocs binary onto each node"
	einfo "(scp /usr/local/bin/openmosixprocs your_node:/usr/local/bin/openmosixprocs)"
	einfo
	einfo "Start openmosixcollector"
	einfo "manually (/etc/init.d/openmosixcollector start) or"
	einfo "automatically using rc-update"
	einfo "(rc-update add /etc/init.d/openmosixcollector default)."
	einfo
	einfo "Run openmosixview by simply typing openmosixview."
	einfo
}
