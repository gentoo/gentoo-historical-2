# Copyright 1999-2002 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-i18n/skk-jisyo/skk-jisyo-200207.ebuild,v 1.3 2002/09/30 15:04:56 stubear Exp $

DESCRIPTION="Jisyo (dictionary) files for the SKK Japanese-input software"

HOMEPAGE="http://www.openlab.jp/skk/"

LICENSE="GPL"

SRC_URI="http://openlab.jp/skk/dic/SKK-JISYO.L.unannotated.bz2
	http://openlab.jp/skk/dic/SKK-JISYO.M.bz2
	http://openlab.jp/skk/dic/SKK-JISYO.S.bz2"

KEYWORDS="x86"                                                                  
SLOT="0"    

DEPEND="virtual/emacs"
RDEPEND="${DEPEND}"

S=${WORKDIR}/${P}

src_unpack () {
	mkdir ${S}
	bzcat ${DISTDIR}/SKK-JISYO.L.unannotated.bz2 > ${WORKDIR}/${P}/SKK-JISYO.L
	bzcat ${DISTDIR}/SKK-JISYO.M.bz2 > ${WORKDIR}/${P}/SKK-JISYO.M
	bzcat ${DISTDIR}/SKK-JISYO.S.bz2 > ${WORKDIR}/${P}/SKK-JISYO.S
}

src_compile () {
	echo "SKK-JISYO don't need to be compiled! ;)"
}

src_install () {
	# install dictionaries
	insinto /usr/share/skk
	doins SKK-JISYO.L
	doins SKK-JISYO.M
	doins SKK-JISYO.S
}
