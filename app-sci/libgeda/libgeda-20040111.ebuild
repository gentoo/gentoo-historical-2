# Copyright 1999-2004 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-sci/libgeda/libgeda-20040111.ebuild,v 1.4 2004/06/24 22:08:21 agriffis Exp $

HOMEPAGE="http://www.geda.seul.org"
DESCRIPTION="libgeda - this library provides functions needed for a working gEDA/gaf system"
SRC_URI="http://www.geda.seul.org/devel/${PV}/libgeda-${PV}.tar.gz"

IUSE=""
LICENSE="GPL-2"
KEYWORDS="~x86 ~ppc"
SLOT="0"

DEPEND=">=dev-libs/glib-1.2.10
	>=x11-libs/gtk+-2.2
	virtual/x11

	>=dev-util/pkgconfig-0.15.0
	>=app-sci/libgdgeda-2.0.15"

src_compile () {

	econf || die
	emake || die

}

src_install () {

	einstall || die
	dodoc AUTHORS CONTRIBUTORS COPYING ChangeLog NEWS README

}
