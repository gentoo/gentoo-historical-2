# Copyright 1999-2003 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/x11-misc/obconf/obconf-1.1.ebuild,v 1.2 2003/09/15 15:18:39 tseng Exp $

S=${WORKDIR}/${P}
DESCRIPTION="ObConf is a tool for configuring the Openbox window manager."
SRC_URI="http://icculus.org/openbox/releases/${P}.tar.gz"
HOMEPAGE="http://icculus.org/openbox/obconf.php"
LICENSE="GPL-2"
KEYWORDS="~x86 ~ppc"
IUSE=""
SLOT="0"

DEPEND=">=x11-libs/gtk+-2
	>=gnome-base/libglade-2
	>=x11-wm/openbox-3.0_beta3"


src_compile() {
	local myconf
	econf ${myconf} || die
	emake || die
}

src_install() {
	make DESTDIR=${D} install || die
}
