# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/x11-libs/libxsettings-client/libxsettings-client-0.10.ebuild,v 1.9 2006/08/07 16:59:30 yvasilev Exp $

inherit libtool

IUSE=""

DESCRIPTION="xsettings provides inter toolkit configuration settings"
HOMEPAGE="http://www.freedesktop.org/standards/xsettings-spec/"
SRC_URI="http://handhelds.org/~mallum/downloadables/Xsettings-client-${PV}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="ppc x86 ~arm"

DEPEND="|| ( (
		x11-proto/xproto
		x11-libs/libX11
		x11-libs/libXt )
	virtual/x11 )"

S=${WORKDIR}/Xsettings-client-${PV}

src_unpack() {
	unpack ${A}
	cd ${S}

	elibtoolize
}

src_compile() {
	econf || die "configure failed"
	emake || die "make failed"
}

src_install() {
	einstall || die "install failed"
	dodoc AUTHORS ChangeLog NEWS README
}
