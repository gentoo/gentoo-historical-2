# Copyright 1999-2002 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-analyzer/netspeed_applet/netspeed_applet-0.2.ebuild,v 1.1 2002/07/13 16:12:21 stroke Exp $

DESCRIPTION="Applet showing network traffic for GNOME 2"
HOMEPAGE="http://mfcn.ilo.de/netspeed_applet/"
SRC_URI="http://mfcn.ilo.de/netspeed_applet/${P}.tar.gz"
LICENSE="GPL-2"
SLOT="0"
KEYWORDS="x86"

DEPEND=">=x11-libs/gtk+-2.0.5
	>=gnome-base/libgnome-2.0.1
	>=gnome-base/libgnomeui-2.0.1
	>=gnome-base/libgtop-2.0.0-r1
	>=gnome-base/gnome-applets-2.0.0-r1"

RDEPEND="${DEPEND}
	>=dev-util/intltool-0.22"

S=${WORKDIR}/${P}

src_compile() {

	./configure \
		--host=${CHOST} \
		--prefix=/usr \
		--infodir=/usr/share/info \
		--mandir=/usr/share/man || die "./configure failed"

	emake || die

}

src_install () {

	dodir /usr/share/pixmaps
	make DESTDIR=${D} install || die
	dodoc README NEWS ChangeLog COPYING AUTHORS INSTALL

}
