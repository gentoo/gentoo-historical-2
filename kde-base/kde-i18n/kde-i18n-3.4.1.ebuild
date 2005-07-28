# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/kde-base/kde-i18n/kde-i18n-3.4.1.ebuild,v 1.11 2005/07/28 12:02:42 gmsoft Exp $

inherit kde

DESCRIPTION="KDE internationalization package"
HOMEPAGE="http://www.kde.org/"
LICENSE="GPL-2"

KEYWORDS="amd64 ppc ppc64 sparc x86 hppa"
IUSE=""
SLOT="${KDEMAJORVER}.${KDEMINORVER}"

need-kde ${PV}

LANGS="ar bg bn br bs ca cs cy da de el en_GB eo es \
	et eu fi fr fy ga he hi hsb hu is it ja lt mk \
	nb nds nl nn pa pl pt pt_BR ro ru se sk sl sr \
	sr@Latn sv ta tg tr uk zh_CN"

for X in ${LANGS} ; do
	SRC_URI="${SRC_URI} linguas_${X}? ( mirror://kde/stable/${PV}/src/kde-i18n/kde-i18n-${X}-${PV}.tar.bz2 )"
done

pkg_setup() {
	if [ -z "${A}" ]; then
		echo
		eerror "You must define a LINGUAS environment variable that contains a list"
		eerror "of the language codes for which languages you would like to install."
		eerror "Look at the LANGS variable inside the ebuild to see the list of"
		eerror "available languages."
		eerror "e.g.: LINGUAS=\"sv de pt\""
		echo
		die
	fi
}

src_unpack() {
	unpack ${A}
	# work around bug 96143
	if [ -e ${WORKDIR}/kde-i18n-pt_BR-3.4.1 ] ; then
		sed -i -e "s:kommander::" ${WORKDIR}/kde-i18n-pt_BR-3.4.1/docs/kdewebdev/Makefile.in
	fi
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
