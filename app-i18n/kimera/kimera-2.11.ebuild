# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-i18n/kimera/kimera-2.11.ebuild,v 1.5 2010/03/27 00:18:15 yngwin Exp $

EAPI=3
inherit qt4-r2

DESCRIPTION="A Japanese input method which supports the XIM protocol"
SRC_URI="mirror://sourceforge.jp/kimera/37271/${P}.tar.gz"
HOMEPAGE="http://kimera.sourceforge.jp/"

SLOT="0"
LICENSE="GPL-3"
KEYWORDS="amd64 x86"
IUSE="+anthy"

DEPEND="x11-libs/qt-core:4
	anthy? ( app-i18n/anthy )
	!anthy? ( app-i18n/canna )"
RDEPEND="${DEPEND}"

DOCS="AUTHORS README*"

src_configure() {
	local myconf="target.path=/usr/$(get_libdir)/${P}"
	use anthy || myconf="${myconf} no_anthy=1"
	eqmake4 kimera.pro ${myconf}
}
