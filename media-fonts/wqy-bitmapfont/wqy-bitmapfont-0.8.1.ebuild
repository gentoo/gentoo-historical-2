# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-fonts/wqy-bitmapfont/wqy-bitmapfont-0.8.1.ebuild,v 1.1 2007/07/29 22:24:03 dirtyepic Exp $

inherit font

DESCRIPTION="WenQuanYi Bitmap Song CJK font"
HOMEPAGE="http://wqy.sourceforge.net/en/"
SRC_URI="mirror://sourceforge/wqy/${PN}-pcf-${PV}-7.tar.gz"
LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~arm ~hppa ~ia64 ~ppc ~s390 ~sh ~x86 ~x86-fbsd"
IUSE=""
DEPEND=""
S="${WORKDIR}/${PN}"
FONT_S="${S}"
FONT_CONF="85-wqy-bitmapsong.conf"

FONT_SUFFIX="pcf.gz"
DOCS="INSTALL* LATEST-IS* STAT README LOGO.PNG CREDIT ChangeLog"

# Only installs fonts
RESTRICT="strip binchecks"

src_compile() {
	cd "${FONT_S}"
	for file in *.pcf; do
		gzip -9 ${file} || die "gzip failed"
	done
}
