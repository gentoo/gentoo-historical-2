# Copyright 1999-2004 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/xfce-extra/xfce4-minicmd/xfce4-minicmd-0.2.0.ebuild,v 1.10 2004/06/24 22:01:37 agriffis Exp $

IUSE=""
MY_P="${PN}-plugin-${PV}"
S=${WORKDIR}/${MY_P}

DESCRIPTION="Xfce4 panel command line plugin"
HOMEPAGE="http://www.xfce.org/"
SRC_URI="http://download.berlios.de/xfce-goodies/${MY_P}.tar.gz"

SLOT="0"
LICENSE="GPL-2"
KEYWORDS="ia64 x86 ppc alpha sparc amd64 hppa ~mips"

RDEPEND=">=x11-libs/gtk+-2.0.6
	dev-libs/libxml2
	xfce-base/xfce4-base"
DEPEND="${RDEPEND}
	dev-util/pkgconfig"

src_install() {
	make DESTDIR=${D} install || die
	dodoc AUTHORS INSTALL COPYING README
}
