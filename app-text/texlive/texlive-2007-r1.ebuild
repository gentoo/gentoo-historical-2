# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-text/texlive/texlive-2007-r1.ebuild,v 1.3 2007/11/06 23:43:27 fmccor Exp $

DESCRIPTION="A complete TeX distribution"
HOMEPAGE="http://tug.org/texlive/"
SRC_URI=""

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~sparc ~x86"
IUSE="cjk context cyrillic doc extra games graphics humanities music omega
	png pstricks publishers science xetex xml X"

LANGS="af ar bg bn cs cy da de el en en_GB eo es et fi fr he hi hr hsb hu hy id
	is it ja ko la ml mn nl no pl pt ro ru sk sl sr sv ta th tr uk vi zh"

for X in ${LANGS}; do
	IUSE="${IUSE} linguas_${X}"
done

# Not an ideal name
PROVIDE="virtual/tetex"

TEXLIVE_CAT="dev-texlive"

DEPEND=">=app-text/texlive-core-2007"
RDEPEND="${DEPEND}
	app-text/psutils
	${TEXLIVE_CAT}/texlive-psutils
	media-gfx/sam2p
	app-text/texi2html
	sys-apps/texinfo
	${TEXLIVE_CAT}/texlive-texinfo
	app-text/t1utils
	dev-util/dialog
	app-text/lcdf-typetools
	=media-libs/freetype-1*
	dev-tex/detex
	>=app-text/dvipdfm-0.13.2d
	png? ( app-text/dvipng )
	X? ( >=app-text/xdvik-22.84.10 )
	${TEXLIVE_CAT}/texlive-basic
	${TEXLIVE_CAT}/texlive-fontsrecommended
	${TEXLIVE_CAT}/texlive-latex
	${TEXLIVE_CAT}/texlive-latex3
	${TEXLIVE_CAT}/texlive-latexrecommended
	>=dev-tex/xcolor-2.11
	>=dev-tex/latex-beamer-3.06
	${TEXLIVE_CAT}/texlive-metapost
		dev-tex/feynmf
	${TEXLIVE_CAT}/texlive-genericrecommended
	extra? (
		dev-tex/chktex
		${TEXLIVE_CAT}/texlive-bibtexextra
		${TEXLIVE_CAT}/texlive-fontsextra
		${TEXLIVE_CAT}/texlive-formatsextra
		${TEXLIVE_CAT}/texlive-genericextra
		${TEXLIVE_CAT}/texlive-latexextra
		${TEXLIVE_CAT}/texlive-mathextra
		${TEXLIVE_CAT}/texlive-plainextra
	)
	xetex? ( ${TEXLIVE_CAT}/texlive-xetex
		>=app-text/xdvipdfmx-0.4 )
	graphics? ( ${TEXLIVE_CAT}/texlive-pictures
		>=dev-tex/pgf-1.18 )
	science? ( ${TEXLIVE_CAT}/texlive-science )
	publishers? ( ${TEXLIVE_CAT}/texlive-publishers )
	music? ( ${TEXLIVE_CAT}/texlive-music )
	pstricks? ( ${TEXLIVE_CAT}/texlive-pstricks )
	omega? ( ${TEXLIVE_CAT}/texlive-omega )
	context? ( ${TEXLIVE_CAT}/texlive-context )
	games? ( ${TEXLIVE_CAT}/texlive-games )
	humanities? ( ${TEXLIVE_CAT}/texlive-humanities )
	xml? ( ${TEXLIVE_CAT}/texlive-htmlxml )
	doc? (
		${TEXLIVE_CAT}/texlive-documentation-base
		linguas_bg? ( ${TEXLIVE_CAT}/texlive-documentation-bulgarian )
		linguas_zh? ( ${TEXLIVE_CAT}/texlive-documentation-chinese )
		linguas_cs? ( ${TEXLIVE_CAT}/texlive-documentation-czechslovak )
		linguas_sk? ( ${TEXLIVE_CAT}/texlive-documentation-czechslovak )
		linguas_nl? ( ${TEXLIVE_CAT}/texlive-documentation-dutch )
		linguas_en? ( ${TEXLIVE_CAT}/texlive-documentation-english )
		linguas_fi? ( ${TEXLIVE_CAT}/texlive-documentation-finnish )
		linguas_fr? ( ${TEXLIVE_CAT}/texlive-documentation-french )
		linguas_de? ( ${TEXLIVE_CAT}/texlive-documentation-german )
		linguas_el? ( ${TEXLIVE_CAT}/texlive-documentation-greek )
		linguas_it? ( ${TEXLIVE_CAT}/texlive-documentation-italian )
		linguas_ja? ( ${TEXLIVE_CAT}/texlive-documentation-japanese )
		linguas_ko? ( ${TEXLIVE_CAT}/texlive-documentation-korean )
		linguas_mn? ( ${TEXLIVE_CAT}/texlive-documentation-mongolian )
		linguas_pl? ( ${TEXLIVE_CAT}/texlive-documentation-polish )
		linguas_pt? ( ${TEXLIVE_CAT}/texlive-documentation-portuguese )
		linguas_ru? ( ${TEXLIVE_CAT}/texlive-documentation-russian )
		linguas_es? ( ${TEXLIVE_CAT}/texlive-documentation-spanish )
		linguas_th? ( ${TEXLIVE_CAT}/texlive-documentation-thai )
		linguas_tr? ( ${TEXLIVE_CAT}/texlive-documentation-turkish )
		linguas_uk? ( ${TEXLIVE_CAT}/texlive-documentation-ukrainian )
		linguas_vi? ( ${TEXLIVE_CAT}/texlive-documentation-vietnamese )
	)
	linguas_af? ( ${TEXLIVE_CAT}/texlive-langafrican )
	linguas_ar? ( ${TEXLIVE_CAT}/texlive-langarab )
	linguas_hy? ( ${TEXLIVE_CAT}/texlive-langarmenian )
	cjk? ( ${TEXLIVE_CAT}/texlive-langcjk )
	linguas_hr? ( ${TEXLIVE_CAT}/texlive-langcroatian )
	cyrillic? ( ${TEXLIVE_CAT}/texlive-langcyrillic )
	linguas_cs? ( ${TEXLIVE_CAT}/texlive-langczechslovak )
	linguas_sk? ( ${TEXLIVE_CAT}/texlive-langczechslovak )
	linguas_da? ( ${TEXLIVE_CAT}/texlive-langdanish )
	linguas_nl? ( ${TEXLIVE_CAT}/texlive-langdutch )
	linguas_fi? ( ${TEXLIVE_CAT}/texlive-langfinnish )
	linguas_fr? ( ${TEXLIVE_CAT}/texlive-langfrench )
	linguas_de? ( ${TEXLIVE_CAT}/texlive-langgerman )
	linguas_el? ( ${TEXLIVE_CAT}/texlive-langgreek )
	linguas_he? ( ${TEXLIVE_CAT}/texlive-langhebrew )
	linguas_hu? ( ${TEXLIVE_CAT}/texlive-langhungarian )
	linguas_bn? ( ${TEXLIVE_CAT}/texlive-langindic )
	linguas_ml? ( ${TEXLIVE_CAT}/texlive-langindic )
	linguas_ta? ( ${TEXLIVE_CAT}/texlive-langindic )
	linguas_hi? ( ${TEXLIVE_CAT}/texlive-langindic )
	linguas_it? ( ${TEXLIVE_CAT}/texlive-langitalian )
	linguas_la? ( ${TEXLIVE_CAT}/texlive-langlatin )
	linguas_zh? ( ${TEXLIVE_CAT}/texlive-langmanju )
	linguas_mn? ( ${TEXLIVE_CAT}/texlive-langmongolian )
	linguas_no? ( ${TEXLIVE_CAT}/texlive-langnorwegian )
	linguas_eo? ( ${TEXLIVE_CAT}/texlive-langother )
	linguas_et? ( ${TEXLIVE_CAT}/texlive-langother )
	linguas_is? ( ${TEXLIVE_CAT}/texlive-langother )
	linguas_id? ( ${TEXLIVE_CAT}/texlive-langother )
	linguas_ro? ( ${TEXLIVE_CAT}/texlive-langother )
	linguas_sr? ( ${TEXLIVE_CAT}/texlive-langother )
	linguas_sl? ( ${TEXLIVE_CAT}/texlive-langother )
	linguas_tr? ( ${TEXLIVE_CAT}/texlive-langother )
	linguas_hsb? ( ${TEXLIVE_CAT}/texlive-langother )
	linguas_cy? ( ${TEXLIVE_CAT}/texlive-langother )
	linguas_pl? ( ${TEXLIVE_CAT}/texlive-langpolish )
	linguas_pt? ( ${TEXLIVE_CAT}/texlive-langportuguese )
	linguas_es? ( ${TEXLIVE_CAT}/texlive-langspanish )
	linguas_sv? ( ${TEXLIVE_CAT}/texlive-langswedish )
	linguas_en_GB? ( ${TEXLIVE_CAT}/texlive-langukenglish )
	linguas_vi? ( ${TEXLIVE_CAT}/texlive-langvietnamese )
"
