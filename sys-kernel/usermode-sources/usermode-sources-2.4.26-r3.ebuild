# Copyright 1999-2004 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sys-kernel/usermode-sources/usermode-sources-2.4.26-r3.ebuild,v 1.1 2004/07/09 17:29:11 plasmaroo Exp $

ETYPE="sources"
inherit kernel eutils

UML_PATCH="uml-patch-2.4.26-1"

DESCRIPTION="Full (vanilla) sources for the User Mode Linux kernel"
SRC_URI="mirror://kernel/linux/kernel/v2.4/linux-${PV}.tar.bz2
	mirror://sourceforge/user-mode-linux/${UML_PATCH}.bz2"
HOMEPAGE="http://www.kernel.org/ http://user-mode-linux.sourceforge.net"
LICENSE="GPL-2"
SLOT="${PV}-${PR}"
KEYWORDS="~x86 -ppc"
EXTRAVERSION="-uml1-${PR}"
RESTRICT="nomirror"

# console-tools is needed to solve the loadkeys fiasco.
# binutils version needed to avoid Athlon/PIII/SSE assembler bugs.
DEPEND=">=sys-devel/binutils-2.11.90.0.31 dev-lang/perl"
RDEPEND=">=sys-libs/ncurses-5.2"

S=${WORKDIR}/linux-${PV}${EXTRAVERSION}

src_unpack() {
	cd ${WORKDIR}
	unpack linux-${PV}.tar.bz2

	mv linux-${PV} ${S} && cd ${S}
	epatch ${DISTDIR}/${UML_PATCH}.bz2
	epatch ${FILESDIR}/${P}.CAN-2004-0394.patch || die "Failed to add the CAN-2004-0394 patch!"
	epatch ${FILESDIR}/${PN}-2.4.CAN-2004-0495.patch || die "Failed to add the CAN-2004-0495 patch!"
	epatch ${FILESDIR}/${PN}.CAN-2004-0497.patch || die "Failed to add the CAN-2004-0497 patch!"
	epatch ${FILESDIR}/${PN}-2.4.CAN-2004-0535.patch || die "Failed to add the CAN-2004-0535 patch!"
	epatch ${FILESDIR}/${PN}-2.4.FPULockup-53804.patch || die "Failed to apply FPU-lockup patch!"
	kernel_universal_unpack
}

src_install() {
	mkdir -p ${D}/usr/src/uml

	# Fix permissions
	cd ${WORKDIR}
	chown -R root:root *
	chmod -R a+r-w+X,u+w *

	mv linux-${PV}${EXTRAVERSION} ${D}/usr/src/uml/
}

pkg_postinst() {
	# Create linux symlink
	if [ ! -e ${ROOT}usr/src/uml/linux ]
	then
		rm -f ${ROOT}usr/src/uml/linux
		ln -sf ${ROOT}usr/src/uml/linux-${PV}${EXTRAVERSION} ${ROOT}usr/src/uml/linux
	fi
}
