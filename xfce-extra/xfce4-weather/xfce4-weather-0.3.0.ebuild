# Copyright 1999-2004 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/xfce-extra/xfce4-weather/xfce4-weather-0.3.0.ebuild,v 1.2 2004/04/05 01:48:53 bcowan Exp $

IUSE=""
MY_P="${PN}-plugin-${PV}"
S=${WORKDIR}/${MY_P}

DESCRIPTION="Xfce panel weather monitor"
HOMEPAGE="http://www.xfce.org/"
SRC_URI="http://download.berlios.de/xfce-goodies/${MY_P}.tar.bz2"

SLOT="0"
LICENSE="GPL-2"
KEYWORDS="~ia64 ~x86 ~ppc ~alpha ~sparc ~amd64"

RDEPEND=">=x11-libs/gtk+-2.0.6
	dev-libs/libxml2
	xfce-base/xfce4-base"
DEPEND="${RDEPEND}
	dev-util/pkgconfig"

src_install() {
	make DESTDIR=${D} install || die
	dodoc AUTHORS INSTALL COPYING README
}
