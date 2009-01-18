# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-fonts/ipamonafont/ipamonafont-1.0.8.ebuild,v 1.6 2009/01/18 14:57:21 klausman Exp $

inherit font

DESCRIPTION="Hacked version of IPA fonts, which is suitable for browsing 2ch"
HOMEPAGE="http://www.geocities.jp/ipa_mona/index.html"
MY_PN="opfc-ModuleHP-1.1.1_withIPAMonaFonts"
SRC_URI="http://www.geocities.jp/ipa_mona/${MY_PN}-${PV}.tar.gz"
LICENSE="grass-ipafonts as-is"

SLOT="0"
KEYWORDS="alpha amd64 ~arm hppa ~ia64 ppc ~s390 ~sh sparc x86 ~x86-fbsd"
IUSE=""

S="${WORKDIR}"

RESTRICT="mirror"

FONT_SUFFIX="ttf"
FONT_S="${S}/${MY_PN}-${PV}/fonts"
