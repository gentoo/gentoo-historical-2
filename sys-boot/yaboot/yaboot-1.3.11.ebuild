# Copyright 1999-2003 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sys-boot/yaboot/yaboot-1.3.11.ebuild,v 1.2 2003/12/17 04:48:59 brad_mssw Exp $

inherit eutils

S=${WORKDIR}/${P}
DESCRIPTION="PPC Bootloader"
SRC_URI="http://penguinppc.org/projects/yaboot/${P}.tar.gz"
HOMEPAGE="http://penguinppc.org/projects/yaboot/"

SLOT="0"
LICENSE="GPL-2"
KEYWORDS="ppc -x86 -amd64 -alpha -arm -hppa -mips -sparc ppc64"

DEPEND="sys-apps/powerpc-utils
	sys-fs/hfsutils
	sys-fs/hfsplusutils"

PROVIDE="virtual/bootloader"

MAKEOPTS='PREFIX=/usr MANDIR=share/man'

src_compile() {
	export -n CFLAGS
	export -n CXXFLAGS
	[ -n "${CC}" ] || CC="gcc"
	# dual boot patch
	epatch ${FILESDIR}/yabootconfig-${PV}.patch
	emake ${MAKEOPTS} CC="${CC}" || die
}

src_install() {
	cp etc/yaboot.conf etc/yaboot.conf.bak
	sed -e 's/\/local//' etc/yaboot.conf >| etc/yaboot.conf.edit
	mv -f etc/yaboot.conf.edit etc/yaboot.conf
	make ROOT=${D} ${MAKEOPTS} install || die
}

