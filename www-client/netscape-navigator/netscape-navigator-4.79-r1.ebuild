# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/www-client/netscape-navigator/netscape-navigator-4.79-r1.ebuild,v 1.1 2005/03/15 20:08:44 seemant Exp $

S=${WORKDIR}/navigator-v479.x86-unknown-linux2.2
DESCRIPTION="Netscape Navigator 4.79"
SRC_URI="ftp://ftp.netscape.com/pub/communicator/english/4.79/unix/supported/linux22/navigator_standalone/navigator-v479-us.x86-unknown-linux2.2.tar.gz"
HOMEPAGE="http://developer.netscape.com/support/index.html"

SLOT="0"
KEYWORDS="x86 -ppc -sparc"
LICENSE="NETSCAPE"

IUSE=""

RDEPEND=">=sys-libs/lib-compat-1.0
	net-www/netscape-flash"

src_unpack() {
	unpack ${A} || die
	ls -la ${S}
#	chown -R root:root ${S}
}

src_install() {
	dodir /opt/netscape
	dodir /opt/netscape/java/classes
	dodir /usr/X11R6/bin
	dodoc README.install
	cd ${D}/opt/netscape
	tar xz --no-same-owner -f ${S}/netscape-v479.nif
	tar xz --no-same-owner -f ${S}/nethelp-v479.nif
#	tar xz --no-same-owner -f ${S}/spellchk-v479.nif
	cp ${S}/*.jar ${D}/opt/netscape/java/classes
	cp ${FILESDIR}/netscape ${D}/usr/X11R6/bin/netscape
	rm ${D}/opt/netscape/netscape-dynMotif
	rm ${D}/opt/netscape/libnullplugin-dynMotif.so
	rm ${D}/opt/netscape/plugins/libflashplayer.so
	insinto /usr/X11R6/bin
	doins ${FILESDIR}/netscape
	chmod +x ${D}/usr/X11R6/bin/netscape
}
