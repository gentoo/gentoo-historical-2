# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-fonts/ttf-gentium/ttf-gentium-1.0.2.ebuild,v 1.2 2006/11/26 23:55:11 flameeyes Exp $

inherit font versionator

MY_P="${PN/-/-sil-}-$(delete_version_separator 2)"

DESCRIPTION="Gentium Typeface"
HOMEPAGE="http://scripts.sil.org/gentium"
SRC_URI="mirror://gentoo/${MY_P}.tar.gz"
#SRC_URI="http://scripts.sil.org/cms/scripts/render_download.php?site_id=nrsi&format=file&media_id=Gentium_102_L_tar&_sc=1&filename=ttf-sil-gentium-1.02.tar.gz"
LICENSE="OFL"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~hppa ~ia64 ~ppc ~ppc64 ~sparc ~x86 ~x86-fbsd"
IUSE="X doc"

DOCS="FONTLOG GENTIUM-FAQ QUOTES README local.conf"
FONT_SUFFIX="ttf"

S="${WORKDIR}/${MY_P}"
FONT_S="${S}"

src_install() {
	font_src_install
	if use doc ; then
		insinto /usr/share/doc/${PN}-${PVR}
		doins *.pdf
	fi
}
