# Copyright 1999-2004 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sys-apps/s390-tools/s390-tools-1.2.4.ebuild,v 1.3 2004/06/24 22:24:46 agriffis Exp $

inherit eutils

STREAM="june2003"

KERNEL_VERSION=2.4.19
BBOX_VERSION=0.60.5
E2FS_PROGS_VERSION=1.32

DESCRIPTION="A set of user space utilities that should be used together with the zSeries (s390) Linux kernel and device drivers"
# must be downloaded from IBM
SRC_URI="mirror://gentoo/${PN}-${PV}-${STREAM}.tar.gz
	http://www.busybox.net/downloads/busybox-${BBOX_VERSION}.tar.bz2
	mirror://sourceforge/e2fsprogs/e2fsprogs-${E2FS_PROGS_VERSION}.tar.gz
	http://www.kernel.org/pub/linux/kernel/v2.4/linux-${KERNEL_VERSION}.tar.bz2"
HOMEPAGE="http://oss.software.ibm.com/developerworks/opensource/linux390/june2003_recommended.shtml"
LICENSE="GPL-2"
KEYWORDS="s390"
SLOT="0"
DEPEND="virtual/glibc
	net-analyzer/ucd-snmp
	app-admin/genromfs"

PROVIDE="virtual/bootloader"

src_unpack() {
	unpack "${PN}-${PV}-${STREAM}.tar.gz"
	cd ${S}; epatch ${FILESDIR}/${P}-vtoc.diff
	cd ${S}; epatch ${FILESDIR}/${P}-ucdsnmp.diff
	for tarball in busybox-${BBOX_VERSION}.tar.bz2 \
			e2fsprogs-${E2FS_PROGS_VERSION}.tar.gz \
			linux-${KERNEL_VERSION}.tar.bz2 ; do
		cp ${DISTDIR}/$tarball ${S}/zfcpdump/extern
	done
}

src_compile() {
	emake || die "emake failed"
}

src_install() {
	einstall INSTROOT=${D}
	prepall
}

