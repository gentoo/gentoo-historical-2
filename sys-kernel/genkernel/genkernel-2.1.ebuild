# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sys-kernel/genkernel/genkernel-2.1.ebuild,v 1.4 2005/01/29 05:32:17 wolf31o2 Exp $

BUSYBOX="busybox-1.00-pre3"
CLOOP="cloop_1.02-1"

DESCRIPTION="Gentoo autokernel script"
HOMEPAGE="http://www.gentoo.org"
SRC_URI="http://dev.gentoo.org/~livewire/distfiles/${P}.tar.bz2
		 http://dev.gentoo.org/~livewire/distfiles/${BUSYBOX}.tar.bz2
		 http://dev.gentoo.org/~zhen/distfiles/${CLOOP}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="-*"
IUSE=""

DEPEND=""

src_unpack() {
	unpack ${P}.tar.bz2
}

src_install() {
	insinto /etc/kernels
	doins files/settings files/default-config-*

	exeinto /usr/sbin
	doexe genkernel

	#Put general files in /usr/share/genkernel for FHS compliance
	insinto /usr/share/genkernel
	doins src/linuxrc files/key.lst src/1024.initrd files/livecdrc \
		${DISTDIR}/${BUSYBOX}.tar.bz2 ${DISTDIR}/${CLOOP}.tar.gz

	dodoc README
	dodoc ChangeLog
}
