# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-fonts/arphicfonts/arphicfonts-0.1-r2.ebuild,v 1.20 2008/05/30 17:37:11 loki_val Exp $

inherit font

DESCRIPTION="Chinese TrueType Arphic Fonts"
HOMEPAGE="http://www.arphic.com.tw/"
SRC_URI="mirror://gnu/non-gnu/chinese-fonts-truetype/gkai00mp.ttf.gz
	 mirror://gnu/non-gnu/chinese-fonts-truetype/bkai00mp.ttf.gz
	 mirror://gnu/non-gnu/chinese-fonts-truetype/bsmi00lp.ttf.gz
	 mirror://gnu/non-gnu/chinese-fonts-truetype/gbsn00lp.ttf.gz"

LICENSE="Arphic"
SLOT="0"
KEYWORDS="alpha amd64 arm hppa ia64 m68k ~mips ppc ppc64 s390 sh sparc x86 ~x86-fbsd"
IUSE="X"

S="${WORKDIR}"
FONT_S="${S}"
FONT_SUFFIX="ttf"
