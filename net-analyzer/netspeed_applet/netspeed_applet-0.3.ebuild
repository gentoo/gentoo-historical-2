# Copyright 1999-2002 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-analyzer/netspeed_applet/netspeed_applet-0.3.ebuild,v 1.2 2002/08/14 12:12:28 murphy Exp $

DESCRIPTION="Applet showing network traffic for GNOME 2"
HOMEPAGE="http://mfcn.ilo.de/netspeed_applet/"
SRC_URI="http://mfcn.ilo.de/netspeed_applet/${P}.tar.gz"

SLOT="0"
LICENSE="GPL-2"
KEYWORDS="x86 sparc sparc64"

DEPEND=">=x11-libs/gtk+-2.0.5
	>=gnome-base/libgnome-2.0.1
	>=gnome-base/libgnomeui-2.0.1
	>=gnome-base/libgtop-2.0.0-r1
	>=gnome-base/gnome-applets-2.0.0-r1"

RDEPEND="${DEPEND}
	>=dev-util/intltool-0.22"

S=${WORKDIR}/${P}

src_compile() {

	econf || die "./configure failed"
	emake || die

}

src_install () {

	dodir /usr/share/pixmaps
	make DESTDIR=${D} install || die
	dodoc README NEWS ChangeLog COPYING AUTHORS INSTALL

}
