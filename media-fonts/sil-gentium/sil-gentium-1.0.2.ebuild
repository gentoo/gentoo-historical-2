# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-fonts/sil-gentium/sil-gentium-1.0.2.ebuild,v 1.5 2009/04/06 17:10:43 armin76 Exp $

inherit font versionator

MY_P="ttf-${PN}-$(delete_version_separator 2)"

DESCRIPTION="SIL Gentium Unicode font for Latin and Greek languages."
HOMEPAGE="http://scripts.sil.org/gentium"
SRC_URI="mirror://gentoo/${MY_P}.tar.gz"

LICENSE="OFL"
SLOT="0"
KEYWORDS="alpha amd64 arm hppa ia64 ppc ppc64 s390 sh sparc x86 ~x86-fbsd"
IUSE="doc"

DOCS="FONTLOG GENTIUM-FAQ QUOTES OFL-FAQ"
FONT_SUFFIX="ttf"

S="${WORKDIR}/${MY_P}"
FONT_S="${S}"

src_install() {
	font_src_install
	use doc && dodoc *.pdf
}
