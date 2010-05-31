# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/x11-misc/oroborus-deskmenu/oroborus-deskmenu-1.4.5.ebuild,v 1.1 2010/05/31 15:49:22 xarthisius Exp $

MY_PN=${PN/oroborus-//}

DESCRIPTION="root menu program for Oroborus"
HOMEPAGE="http://www.oroborus.org"
SRC_URI="http://ftp.debian.org/debian/pool/main/d/${MY_PN}/${MY_PN}_${PV}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND="=x11-libs/gtk+-2*
	!x11-wm/oroborus-extras"
DEPEND="${RDEPEND}
	dev-util/pkgconfig"

S=${WORKDIR}/${MY_PN}-${PV}

src_install() {
	emake DESTDIR="${D}" install || die
	dodoc AUTHORS ChangeLog NEWS README TODO example_rc || die
}
