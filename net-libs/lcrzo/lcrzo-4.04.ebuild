# Copyright 1999-2002 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License, v2 or later
# Author: Donny Davies <woodchip@gentoo.org>
# $Header: /var/cvsroot/gentoo-x86/net-libs/lcrzo/lcrzo-4.04.ebuild,v 1.1 2002/02/18 20:07:46 karltk Exp $

DESCRIPTION="Library of Ethernet, IP, UDP, TCP, ICMP, ARP and RARP protocols"
HOMEPAGE="http://www.laurentconstantin.com/en/lcrzo/"
SRC_URI="http://www.laurentconstantin.com/common/${PN}/download/v4/${P}-src.tgz"
S=${WORKDIR}/${P}-src

DEPEND="virtual/glibc net-libs/libpcap"

src_unpack() {
	unpack ${A} ; cd ${S}/src

	# genemake checks that these directories exist...
	mv genemake genemake.orig
	sed -e "s:/usr/local/include:/usr/include:" \
		-e "s:/usr/local/lib:/usr/lib:" \
		-e "s:/usr/local/bin:/usr/bin:" \
		-e "s:/usr/local/man/man1:/usr/share/man/man1:" \
		-e "s:/usr/local/man/man3:/usr/share/man/man3:" \
		genemake.orig > genemake

	chmod 755 genemake
	./genemake || die "problem creating Makefile"

	# plug in our CFLAGS and make it install into ${D}...
	mv Makefile Makefile.orig
	sed -e "s:^GCCOPT=.*:GCCOPT=${CFLAGS}:" \
		-e "s:^GCCOPTL=.*:GCCOPTL=${CFLAGS}:" \
		-e "s:^GCCOPTP=.*:GCCOPTP=${CFLAGS}:" \
		-e "s:^INSTINCLUDE=:INSTINCLUDE=${D}:" \
		-e "s:^INSTLIB=:INSTLIB=${D}:" \
		-e "s:^INSTBIN=:INSTBIN=${D}:" \
		-e "s:^INSTMAN1=:INSTMAN1=${D}:" \
		-e "s:^INSTMAN3=:INSTMAN3=${D}:" \
		Makefile.orig > Makefile
}

src_compile() {
	make -C src || die "compile problem :("
}

src_install() {
	dodir /usr/{bin,include,lib} /usr/share/man/{man1,man3}
	make -C src install || die
	dodoc doc/*.txt
}
