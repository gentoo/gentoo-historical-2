# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-fonts/cheapskatefonts/cheapskatefonts-1.0.ebuild,v 1.3 2005/08/23 14:39:45 gustavoz Exp $

inherit font

DESCRIPTION="Dustismo's decorative font collection"
HOMEPAGE="http://www.dustismo.com/site/fonts.html"
SRC_URI="http://www.dustismo.com/fonts/Domestic_Manners.zip
	http://www.dustismo.com/fonts/PenguinAttack.zip
	http://www.dustismo.com/fonts/Dustismo.zip
	http://www.dustismo.com/fonts/El_Abogado_Loco.zip
	http://www.dustismo.com/fonts/Progenisis.zip
	http://www.dustismo.com/fonts/flatline.zip
	http://www.dustismo.com/fonts/MarkedFool.zip
	http://www.dustismo.com/fonts/ItWasntMe.zip
	http://www.dustismo.com/fonts/balker.zip
	http://www.dustismo.com/fonts/Swift.zip
	http://www.dustismo.com/fonts/Wargames.zip
	http://www.dustismo.com/fonts/Winks.zip"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~x86 ~amd64 ~sparc"
IUSE=""

DEPEND="app-arch/unzip"
RDEPEND=""

S=${WORKDIR}
FONT_S=${S}
FONT_SUFFIX="ttf"

src_unpack() {
	for zip in ${A} ; do
		echo ">>> Unpacking ${zip} to ${WORKDIR}"
		unzip -n ${DISTDIR}/${zip} > /dev/null \
			|| die "failed to unpack ${zip}"
	done
}
