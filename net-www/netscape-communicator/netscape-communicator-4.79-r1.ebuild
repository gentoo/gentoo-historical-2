# Copyright 1999-2003 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-www/netscape-communicator/netscape-communicator-4.79-r1.ebuild,v 1.10 2003/03/02 04:33:48 vapier Exp $

S=${WORKDIR}/communicator-v479.x86-unknown-linux2.2
DESCRIPTION="Netscape Communicator 4.79"
SRC_URI="ftp://ftp.netscape.com/pub/communicator/english/4.79/unix/supported/linux22/complete_install/communicator-v479-us.x86-unknown-linux2.2.tar.gz"
HOMEPAGE="http://developer.netscape.com/support/index.html"

SLOT="0"
KEYWORDS="x86 -ppc sparc"
LICENSE="NETSCAPE"

DEPEND="virtual/glibc"
RDEPEND=">=sys-libs/lib-compat-1.0
	net-www/netscape-flash"

src_install() {
	dodir /opt/netscape
	dodir /opt/netscape/java/classes
	dodir /usr/X11R6/bin
	dodoc README.install
	cd ${D}/opt/netscape
	
	tar xz --no-same-owner -f ${S}/netscape-v479.nif
	tar xz --no-same-owner -f ${S}/nethelp-v479.nif
	tar xz --no-same-owner -f ${S}/spellchk-v479.nif
	
	cp ${S}/*.jar ${D}/opt/netscape/java/classes
	cp ${FILESDIR}/netscape ${D}/usr/X11R6/bin/netscape
	rm ${D}/opt/netscape/netscape-dynMotif
	rm ${D}/opt/netscape/libnullplugin-dynMotif.so
	rm ${D}/opt/netscape/plugins/libflashplayer.so
	insinto /usr/X11R6/bin
	doins ${FILESDIR}/netscape 
	chmod +x ${D}/usr/X11R6/bin/netscape
}
