# Copyright 1999-2002 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-i18n/skk-jisyo/skk-jisyo-200211.ebuild,v 1.1 2002/11/06 06:03:41 nakano Exp $

DESCRIPTION="Jisyo (dictionary) files for the SKK Japanese-input software"
HOMEPAGE="http://openlab.ring.gr.jp/skk/"
LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~x86 ~ppc ~sparc ~sparc64 ~alpha"

MY_PN="`echo ${PN} | gawk '{ print toupper($1) }'`"
SRC_PATH="http://gentoojp.sourceforge.jp/distfiles/${PN}"
SRC_URI="${SRC_PATH}/${MY_PN}.L.unannotated.${PV}.bz2
	${SRC_PATH}/${MY_PN}.M.${PV}.bz2
	${SRC_PATH}/${MY_PN}.S.${PV}.bz2"

DEPEND="sys-apps/bzip2
	sys-apps/gawk"

RDEPEND=""

S=${WORKDIR}

src_unpack() {
	unpack ${A}
}

src_compile () {
	echo "${MY_PN} don't need to be compiled! ;)"
}

src_install () {
	# install dictionaries
	insinto /usr/share/skk
	newins ${MY_PN}.L.unannotated.${PV} ${MY_PN}.L || die
	newins ${MY_PN}.M.${PV} ${MY_PN}.M || die
	newins ${MY_PN}.S.${PV} ${MY_PN}.S || die
}
