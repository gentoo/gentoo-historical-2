# Copyright 1999-2004 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sys-kernel/ck-sources/ck-sources-2.4.25-r1.ebuild,v 1.4 2004/04/17 19:03:26 aliz Exp $

IUSE=""

# OKV=original kernel version, KV=patched kernel version.  

ETYPE="sources"

inherit kernel eutils

# CKV=con kolivas release version
CKV=lck${PR/r/}
# KV=patched kernel version
KV="${PV/_/-}-${CKV}"
# OKV=original kernel version as provided by ebuild
OKV="`echo ${KV} | cut -d- -f1`"
# OKVLAST=(working) last digit of OKV
OKVLAST="`echo ${OKV} | cut -d. -f3`"
# OKVLASTPR=the previous kernel version (for a marcelo pre/rc release)
OKVLASTPR="`expr ${OKVLAST} - 1`"
# If _ isn't there, then it's a stable+ac, otherwise last-stable+pre/rc+ac
PRERC="`echo ${PV}|grep \_`"

# Other working variables
S=${WORKDIR}/linux-${KV}
EXTRAVERSION="`echo ${KV}|sed -e 's:[^-]*\(-.*$\):\1:'`"
BASE="`echo ${KV}|sed -e s:${EXTRAVERSION}::`"

# If it's a last-stable+pre/rc+ac (marcelo), we need to handle it differently
# ourkernel is the stable kernel we'll be working with (previous or current)
if [ ${PRERC} ]; then
	OURKERNEL="2.4.${OKVLASTPR}"
	SRC_URI="mirror://kernel/linux/kernel/v2.4/linux-${OURKERNEL}.tar.bz2
		http://www.plumlocosoft.com/kernel/patches/2.4/${PV}/${KV}/patch-${KV}.bz2
		mirror://kernel/linux/kernel/v2.4/testing/patch-${PV/_/-}.bz2"
else
	OURKERNEL="2.4.${OKVLAST}"
	SRC_URI="mirror://kernel//linux/kernel/v2.4/linux-${OURKERNEL}.tar.bz2
		http://www.plumlocosoft.com/kernel/patches/2.4/${PV}/${KV}/patch-${KV}.bz2"
fi

DESCRIPTION="Full sources for the Stock Linux kernel Con Kolivas's high performance patchset"
HOMEPAGE="http://members.optusnet.com.au/ckolivas/kernel/"

KEYWORDS="~x86 -ppc"
SLOT="${KV}"

src_unpack() {
	unpack linux-${OURKERNEL}.tar.bz2
	mv linux-${OURKERNEL} linux-${KV} || die
	cd linux-${KV}

	# if we need a pre/rc patch, then use it
	if [ ${PRERC} ]; then
		bzcat ${DISTDIR}/patch-${PV/_/-}.bz2|patch -p1 || die "-marcelo patch failed"
	fi

	bzcat ${DISTDIR}/patch-${KV}.bz2|patch -p1 || die "-lck patch failed!"
	epatch ${FILESDIR}/${P}.CAN-2004-0109.patch || die "Failed to patch CAN-2004-0109 vulnerability!"
	epatch ${FILESDIR}/${P}.CAN-2004-0177.patch || die "Failed to add the CAN-2004-0177 patch!"
	epatch ${FILESDIR}/${P}.CAN-2004-0178.patch || die "Failed to add the CAN-2004-0178 patch!"

	kernel_universal_unpack
}
