# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-fonts/mikachan-font-ttf/mikachan-font-ttf-8.9-r1.ebuild,v 1.13 2006/11/29 23:33:29 jer Exp $

inherit font

MY_PN="mikachanfont"

DESCRIPTION="Mikachan Japanese TrueType fonts"
SRC_URI="mirror://sourceforge.jp/mikachan/5513/${MY_PN}-${PV}.tar.bz2
	mirror://sourceforge.jp/mikachan/5514/${MY_PN}P-${PV}.tar.bz2
	mirror://sourceforge.jp/mikachan/5515/${MY_PN}PB-${PV}.tar.bz2
	mirror://sourceforge.jp/mikachan/5516/${MY_PN}PS-${PV}.tar.bz2"
HOMEPAGE="http://mikachan-font.com/"

LICENSE="free-noncomm"
SLOT="0"
KEYWORDS="alpha amd64 ~arm hppa ia64 ppc ~ppc64 ~s390 ~sh sparc x86 ~x86-fbsd"
IUSE=""

S="${WORKDIR}"
FONT_S="${S}"
FONT_SUFFIX="ttf"

# Only installs fonts
RESTRICT="strip binchecks"

src_install() {
	insinto /usr/share/fonts/${PN}

	for f in "${MY_PN}" "${MY_PN}P" "${MY_PN}PB" "${MY_PN}PS" ; do
		cd "${WORKDIR}/${f}-${PV}"
		doins fonts/*.ttf
		newdoc README README.${f}
		newdoc README.ja README.ja.${f}
		newdoc ChangeLog ChangeLog.${f}
	done

	font_xfont_config
	font_xft_config
}
