# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-games/mercator/mercator-0.2.5.ebuild,v 1.1 2007/02/01 21:03:06 tupone Exp $

inherit eutils

DESCRIPTION="WorldForge library primarily aimed at terrain."
HOMEPAGE="http://www.worldforge.org/dev/eng/libraries/mercator"
SRC_URI="mirror://sourceforge/worldforge/${P}.tar.gz"

LICENSE="GPL-2"
KEYWORDS="~x86"
IUSE="doc"
SLOT="0"

RDEPEND=">=dev-games/wfmath-0.3.2"
DEPEND="${REDEPEND}
	dev-util/pkgconfig"

src_compile() {
	econf || die "econf failed"
	emake || die "make failed"
	if use doc; then
		emake docs || die "Making doc failed"
	fi
}

src_install() {
	emake DESTDIR="${D}" install || die "install failed"
	dodoc AUTHORS ChangeLog NEWS README TODO || die "Installing doc failed"
	if use doc; then
		dohtml doc/html/*  || die "Installing html failed"
	fi
}
