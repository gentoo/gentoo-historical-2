# Copyright 1999-2004 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sys-apps/x86info/x86info-1.11.ebuild,v 1.7 2004/05/05 06:20:51 lv Exp $

inherit eutils

DESCRIPTION="Dave Jones' handy, informative x86 CPU diagnostic utility"

HOMEPAGE="http://www.codemonkey.org.uk/x86info/"

SRC_URI="http://www.codemonkey.org.uk/x86info/${P}.tgz"

LICENSE="GPL-2"

SLOT="0"

KEYWORDS="x86 -amd64 -ppc -sparc -mips -alpha -hppa"

DEPEND="virtual/kernel"

RDEPEND=""

IUSE=""

S=${WORKDIR}/${P}

src_compile() {
	emake x86info CFLAGS="${CFLAGS}" ||die "emake failed"
}

src_install() {
	# binaries first
	into /usr
	dobin x86info
	# modules stuff next
	insinto /etc/modules.d
	newins ${FILESDIR}/x86info-modules.conf-rc x86info
	# now we all all the docs
	dodoc TODO README COPYING ChangeLog
	doman x86info.1
	cp -a results ${D}/usr/share/doc/${PF}
	# prepalldocs rocks! I saw it in net-fs/samba/samba-2.2.8
	prepalldocs
	# create device nodes for x86info
	# based off the scripts/makenode
	# there isn't any proper devfs support in cpuid/msr
	mkdir -p ${D}/dev/cpu
	local numprocs
	#subtract one because we are using a 0-based count
	numprocs=$((`grep '^processor' /proc/cpuinfo | wc -l`-1))
	for i in `seq 0 $numprocs`; do
		mkdir ${D}/dev/cpu/$i
		mknod ${D}/dev/cpu/$i/cpuid c 203 $i 2>/dev/null
		mknod ${D}/dev/cpu/$i/msr c 202 $i 2>/dev/null
	done
}

pkg_postinst() {
	ewarn "Your kernel must be built with the following options"
	ewarn "set to Y or M"
	ewarn "     Processor type and features ->"
	ewarn "         [*] /dev/cpu/*/msr - Model-specific register support"
	ewarn "         [*] /dev/cpu/*/cpuid - CPU information support"
	# copied from media-libs/svgalib/svgalib-1.9.17
	[ "${ROOT}" = "/" ] && /sbin/modules-update &> /dev/null
}


