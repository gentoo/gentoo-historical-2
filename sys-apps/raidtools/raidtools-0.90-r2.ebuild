# Copyright 1999-2002 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sys-apps/raidtools/raidtools-0.90-r2.ebuild,v 1.12 2002/10/19 03:21:24 vapier Exp $

S=${WORKDIR}/raidtools-0.90
DESCRIPTION="Linux RAID 0/1/4/5 utilities"
SRC_URI="http://people.redhat.com/mingo/raid-patches/raidtools-dangerous-0.90-20000116.tar.gz"
DEPEND="virtual/glibc"
RDEPEND="${DEPEND}"
HOMEPAGE="http://people.redhat.com/mingo/raidtools/"
KEYWORDS="x86 ppc sparc sparc64"
SLOT="0"
LICENSE="GPL-2"

src_compile() {
	./configure || die
	cp Makefile Makefile.orig
	sed -e "s/-O2//" -e "s/ -g/ /" Makefile.orig > Makefile
	#emake appears to kill this every now and then (drobbins, 15 Sep 2002)
	make || die
}

src_install() {
	into /
	dosbin mkraid raidstart mkpv
	for x in raidstop raidhotadd raidhotremove raidsetfaulty
	do
		dosym raidstart /sbin/${x}
	done
	dosym mkraid /sbin/raid0run

	if [ -z "`use build`" ]
	then
		doman *.8 *.5
		dodoc COPYING README
		docinto txt
		dodoc Software-RAID.HOWTO/Software-RAID.HOWTO.txt
		dohtml Software-RAID.HOWTO/Software-RAID.HOWTO.html
		dohtml Software-RAID.HOWTO/Software-RAID.HOWTO.sgml
		docinto config
		dodoc *.sample
	fi
}
