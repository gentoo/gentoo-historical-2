# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-libs/opencore-amr/opencore-amr-0.1.2.ebuild,v 1.1 2009/10/11 08:48:08 ssuominen Exp $

EAPI=2
inherit multilib

DESCRIPTION="Implementation of Adaptive Multi Rate Narrowband and Wideband speech codec"
HOMEPAGE="http://opencore-amr.sourceforge.net/"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.gz"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~hppa ~ppc ~ppc64 ~x86 ~x86-fbsd"
IUSE=""

src_configure() {
	econf \
		--disable-dependency-tracking \
		--disable-static
}

src_install() {
	emake DESTDIR="${D}" install || die
	dodoc AUTHORS ChangeLog README
	find "${D}"usr/$(get_libdir) -name '*.la' -delete
}
