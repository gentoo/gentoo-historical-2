# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/kde-base/kde-i18n/kde-i18n-3.5.0_beta2.ebuild,v 1.1 2005/10/15 11:08:40 greg_g Exp $

inherit kde

DESCRIPTION="KDE internationalization package"
HOMEPAGE="http://www.kde.org/"
LICENSE="GPL-2"

KEYWORDS="~amd64 ~hppa ~ppc ~ppc64 ~sparc ~x86"
IUSE=""
SLOT="${KDEMAJORVER}.${KDEMINORVER}"

need-kde ${PV}

LANGS="af ar az bg bn br bs ca cs cy da de el en_GB eo es et
eu fa fi fr fy ga gl he hi hr hu is it ja ko lt lv mk
mn ms nb nds nl nn pa pl pt pt_BR ro ru rw se sk sl sr
sr@Latn ss sv ta tg tr uk uz zh_CN zh_TW"

for X in ${LANGS} ; do
	#SRC_URI="${SRC_URI} linguas_${X}? ( mirror://kde/stable/${PV}/src/kde-i18n/kde-i18n-${X}-${PV}.tar.bz2 )"
	SRC_URI="${SRC_URI} linguas_${X}? ( mirror://kde/unstable/3.5-beta2/src/kde-i18n/kde-i18n-${X}-3.4.92.tar.bz2 )"
done

pkg_setup() {
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
}

src_unpack() {
	# Override kde_src_unpack.
	unpack ${A}
}

src_compile() {
	local _S=${S}
	for dir in `ls ${WORKDIR}`; do
		S=${WORKDIR}/${dir}
		kde_src_compile myconf
		myconf="${myconf} --prefix=${KDEDIR}"
		kde_src_compile configure
		kde_src_compile make
	done
	S=${_S}
}

src_install() {
	local _S=${S}
	for dir in `ls ${WORKDIR}`; do
		cd ${WORKDIR}/${dir}
		make DESTDIR=${D} install || die
	done
	S=${_S}
}
