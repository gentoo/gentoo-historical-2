# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-texlive/texlive-fontsextra/texlive-fontsextra-2007.ebuild,v 1.16 2008/07/14 07:08:38 aballier Exp $

TEXLIVE_MODULES_DEPS="dev-texlive/texlive-basic
"
TEXLIVE_MODULE_CONTENTS="accfonts ai albertus aleph allrunes antiqua antt apl ar archaic arev ascii astro atqolive augie aurical barcode2 barcodes bayer bbding bbm bbold belleek bera blacklettert1 bookhands braille brushscr calligra cherokee cirth clarendo cm-lgc cm-super cmastro cmbright cmll cmpica coronet courier-scaled cryst dancers dice dictsym dingbat doublestroke duerer ean ecc eco eiad elvish epsdice esvect eulervm euxm feyn foekfont fourier frcursive futhark garamond genealogy gothic greenpoint groff grotesq hands hfbright hfoldsty hieroglf ifsym iwona kixfont knuthotherfonts lettrgth lfb linearA logic ly1 marigold mathdesign morse nkarta oca ocherokee ocr-a oesch ogham oinuit optima osmanian pacioli pclnfss phaistos phonetic psafm punk sauter sauterfonts semaphor simpsons skull tapir tengwarscript tpslifonts trajan umrand univers universa wsuipa yfonts zefonts collection-fontsextra
"
inherit texlive-module
DESCRIPTION="TeXLive Extra fonts"

LICENSE="GPL-2 LPPL-1.3c"
SLOT="0"
KEYWORDS="alpha amd64 hppa ia64 ppc ppc64 sparc x86 ~x86-fbsd"
IUSE=""
