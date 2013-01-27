# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/kde-base/kde-l10n/kde-l10n-4.9.5.ebuild,v 1.3 2013/01/27 15:11:59 ago Exp $

EAPI=4

inherit kde4-base

DESCRIPTION="KDE internationalization package"

DEPEND="
	sys-devel/gettext
"
RDEPEND="!<kde-misc/konq-plugins-4.6"

KEYWORDS="amd64 ~arm ~ppc x86 ~amd64-linux ~x86-linux"
IUSE="+handbook"

# /usr/portage/distfiles $ ls -1 kde-l10n-*-${PV}.* |sed -e 's:-${PV}.tar.xz::' -e 's:kde-l10n-::' |tr '\n' ' '
MY_LANGS="ar bg bs ca ca@valencia cs da de el en_GB es et eu fa fi fr ga gl he
hi hr hu ia is it ja kk km ko lt lv nb nds nl nn pa pl pt pt_BR ro ru si sk sl
sr sv tg th tr ug uk vi wa zh_CN zh_TW"

URI_BASE="${SRC_URI/-${PV}.tar.xz/}"
SRC_URI=""

for MY_LANG in ${MY_LANGS} ; do
	IUSE="${IUSE} linguas_${MY_LANG}"
	SRC_URI="${SRC_URI} linguas_${MY_LANG}? ( ${URI_BASE}/${PN}-${MY_LANG}-${PV}.tar.xz )"
done

S="${WORKDIR}"

src_unpack() {
	local LNG DIR
	if [[ -z ${A} ]]; then
		elog
		elog "You either have the LINGUAS variable unset, or it only"
		elog "contains languages not supported by ${P}."
		elog "You won't have any additional language support."
		elog
		elog "${P} supports these language codes:"
		elog "${MY_LANGS}"
		elog
	fi

	[[ -n ${A} ]] && unpack ${A}
	cd "${S}"

	# add all linguas to cmake
	if [[ -n ${A} ]]; then
		for LNG in ${LINGUAS}; do
			DIR="${PN}-${LNG}-${PV}"
			if [[ -d "${DIR}" ]] ; then
				echo "add_subdirectory( ${DIR} )" >> "${S}"/CMakeLists.txt
			fi
		done
	fi
}

src_prepare() {
	find "${S}" -name CMakeLists.txt -type f \
		-exec sed -i -e 's:^ *add_subdirectory( *kdepim-runtime *):# no kdepim-runtime:g' {} +
	find "${S}" -name CMakeLists.txt -type f \
		-exec sed -i -e 's:^ *add_subdirectory( *kdepim *):# no kdepim:g' {} +

	kde4-base_src_prepare
}

src_configure() {
	mycmakeargs=(
		$(cmake-utils_use_build handbook docs)
	)
	[[ -n ${A} ]] && kde4-base_src_configure
}

src_compile() {
	[[ -n ${A} ]] && kde4-base_src_compile
}

src_test() {
	[[ -n ${A} ]] && kde4-base_src_test
}

src_install() {
	[[ -n ${A} ]] && kde4-base_src_install
}
