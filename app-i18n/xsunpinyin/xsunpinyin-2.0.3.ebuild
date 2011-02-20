# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-i18n/xsunpinyin/xsunpinyin-2.0.3.ebuild,v 1.2 2011/02/20 06:49:18 qiaomuf Exp $

EAPI="1"
inherit scons-utils

DESCRIPTION="The SunPinyin IMEngine Wrapper for XIM Framework"
HOMEPAGE="http://sunpinyin.googlecode.com"
SRC_URI="${HOMEPAGE}/files/${P}.tar.gz"

LICENSE="LGPL-2.1 CDDL"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND="app-i18n/sunpinyin
		x11-libs/gtk+:2
		x11-libs/libX11"
RDEPEND="${DEPEND}"

src_compile() {
	escons --prefix="/usr"
}

src_install() {
	escons --prefix="/usr" --install-sandbox="${D}" install
}
