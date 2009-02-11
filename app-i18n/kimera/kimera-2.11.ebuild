# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-i18n/kimera/kimera-2.11.ebuild,v 1.1 2009/02/11 01:22:06 matsuu Exp $

EAPI=1
inherit eutils multilib qt4

DESCRIPTION="A Japanese input method which supports the XIM protocol"
SRC_URI="mirror://sourceforge.jp/kimera/37271/${P}.tar.gz"
HOMEPAGE="http://kimera.sourceforge.jp/"

SLOT="0"
LICENSE="GPL-3"
KEYWORDS="~amd64 ~x86"
IUSE="+anthy"

DEPEND="|| ( x11-libs/qt-core:4 x11-libs/qt:4 )
	anthy? ( app-i18n/anthy )
	!anthy? ( app-i18n/canna )"
RDEPEND="${DEPEND}"

src_unpack() {
	unpack ${A}
	cd "${S}"

	epatch "${FILESDIR}"/${P}-gentoo.patch
}

src_compile() {
	local myconf="target.path=/usr/$(get_libdir)/${P}"

	use anthy || myconf="${myconf} no_anthy=1"

	eqmake4 kimera.pro ${myconf} || die
	emake || die
}

src_install(){
	emake INSTALL_ROOT="${D}" install || die

	dodoc AUTHORS README*
}
