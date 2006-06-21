# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-text/bibletime/bibletime-1.6_beta2.ebuild,v 1.3 2006/06/21 13:51:48 nixnut Exp $

inherit kde eutils versionator

MY_P="${PN}-$(replace_version_separator 2 '')"
S=${WORKDIR}/${MY_P}

DESCRIPTION="KDE Bible study application using the SWORD library."
HOMEPAGE="http://www.bibletime.info/"
SRC_URI="mirror://sourceforge/bibletime/${MY_P}.tar.bz2"
LICENSE="GPL-2"

SLOT="0"
KEYWORDS="~amd64 ~ppc ~x86"
IUSE=""

DEPEND=">=app-text/sword-1.5.8
	dev-cpp/clucene"

LANGS_PKG=${PN}-i18n-1.5.3
LANGS="af bg cs da de en_GB es fi fr hu it ko nl nn_NO no pl pt_BR ro ru sk ua"
LANGS_DOC="bg cs de fi fr it ko nl pt_BR ru"

for X in ${LANGS}; do
	SRC_URI="${SRC_URI} linguas_${X}? ( mirror://sourceforge/bibletime/${LANGS_PKG}.tar.bz2 )"
done

need-kde 3.4

pkg_setup() {
	if ! built_with_use app-text/sword curl; then
		echo
		ewarn "The SWORD library may not have been compiled with curl support."
		ewarn "If you wish to use BibleTime's ability to download modules"
		ewarn "straight from the SWORD website, please make sure app-text/sword"
		ewarn "was compiled with USE=\"curl\"."
		ewarn "Press ctrl+c to abort the merge of BibleTime if you want to"
		ewarn "recompile SWORD with curl support."
		echo
		ebeep 5
	fi
}

src_unpack() {
	kde_src_unpack
	epatch ${FILESDIR}/${P}-gcc4.patch

	local MAKE_LANGS MAKE_LANGS_DOC
	for X in ${LANGS}; do
		use linguas_${X} && MAKE_LANGS="${MAKE_LANGS} ${X/pt_BR/pt_br}.po"
	done
	for X in ${LANGS_DOC}; do
		use linguas_${X} && MAKE_LANGS_DOC="${MAKE_LANGS_DOC} ${X/pt_BR/pt-br}"
	done

	if [ -d "${WORKDIR}/${LANGS_PKG}" ]; then
		cd "${WORKDIR}/${LANGS_PKG}"
		sed -i -e "s,^POFILES.*,POFILES = ${MAKE_LANGS}," po/Makefile.am
		sed -i -e "s,^SUBDIRS.*,SUBDIRS = ${MAKE_LANGS_DOC}," docs/Makefile.am
		make -f admin/Makefile.common || die
	fi
}

src_compile() {
	kde_src_compile

	local _S="${S}"
	if [ -d "${WORKDIR}/${LANGS_PKG}" ]; then
		S="${WORKDIR}/${LANGS_PKG}"
		cd "${S}"
		kde_src_compile
	fi
	S="${_S}"
}

src_install() {
	kde_src_install

	local _S="${S}"
	if [ -d "${WORKDIR}/${LANGS_PKG}" ]; then
		S="${WORKDIR}/${LANGS_PKG}"
		cd "${S}"
		kde_src_install
	fi
	S="${_S}"
}
