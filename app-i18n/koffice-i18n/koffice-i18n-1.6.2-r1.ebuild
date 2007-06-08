# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-i18n/koffice-i18n/koffice-i18n-1.6.2-r1.ebuild,v 1.2 2007/06/08 18:28:33 flameeyes Exp $

inherit kde

RV="${PV}"

DESCRIPTION="KOffice internationalization package."
HOMEPAGE="http://www.koffice.org/"
LICENSE="GPL-2"

SLOT="0"
KEYWORDS="~alpha ~amd64 ~hppa ~ia64 ~ppc ~ppc64 ~sparc ~x86 ~x86-fbsd"
IUSE=""

RDEPEND="|| ( >=app-office/koffice-libs-${PV} >=app-office/koffice-${PV} )
	kde-base/kde-i18n"
need-kde 3.5

LANGS="ca cs cy da de el en_GB es et eu fi fr hu it ja lv ms nb nl pl pt pt_BR ru sk sl sr sr@Latn sv uk zh_CN zh_TW"

for X in ${LANGS}; do
	SRC_URI="${SRC_URI} linguas_${X}? ( mirror://kde/stable/koffice-${PV/_/-}/src/koffice-l10n/koffice-l10n-${X}-${RV/_/-}.tar.bz2 )"
	IUSE="${IUSE} linguas_${X}"
done

src_unpack() {
	if [ -z "${A}" ]; then
		echo
		eerror "You must set the LINGUAS environment variable to a list of valid"
		eerror "language codes, one for each language you would like to install."
		eerror "e.g.: LINGUAS=\"sv de pt\""
		eerror ""
		eerror "The available language codes are:"
		echo "${LANGS}"
		echo
		die
	fi

	unpack ${A}
}

src_compile() {
	local _S="${S}"
	local _KDE_S="${KDE_S}"
	for dir in ${WORKDIR}/*; do
		S=${dir}
		KDE_S=${dir}
		kde_src_compile
	done
	S="${_S}"
	KDE_S="${_KDE_S}"
}

src_install() {
	local _S="${S}"
	for dir in ${WORKDIR}/*; do
		cd ${dir}
		make DESTDIR=${D} install
	done
	S="${_S}"
}
