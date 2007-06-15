# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/mail-client/mozilla-thunderbird-bin/mozilla-thunderbird-bin-2.0.0.4.ebuild,v 1.2 2007/06/15 17:20:13 armin76 Exp $

inherit eutils mozilla-launcher multilib mozextension

LANGS="be bg ca cs da de el en-GB es-AR es-ES eu fi fr ga-IE hu it ja lt mk nb-NO nl nn-NO pa-IN pl pt-BR pt-PT ru sk sl sv-SE tr zh-CN zh-TW"
NOSHORTLANGS="en-GB es-AR pt-BR zh-TW"

DESCRIPTION="The Mozilla Thunderbird Mail & News Reader"
SRC_URI="http://releases.mozilla.org/pub/mozilla.org/thunderbird/releases/${PV}/linux-i686/en-US/thunderbird-${PV}.tar.gz"
HOMEPAGE="http://www.mozilla.org/projects/thunderbird"
RESTRICT="nostrip"

KEYWORDS="-* ~amd64 x86"
SLOT="0"
LICENSE="MPL-1.1 GPL-2 LGPL-2.1"
IUSE=""

for X in ${LANGS} ; do
	SRC_URI="${SRC_URI} linguas_${X/-/_}? (	http://dev.gentooexperimental.org/~armin76/dist/${P/-bin}-xpi/${P/-bin}-${X}.xpi )"
	IUSE="${IUSE} linguas_${X/-/_}"
done

for X in ${SHORTLANGS} ; do
	SRC_URI="${SRC_URI} linguas_${X%%-*}? (	http://dev.gentooexperimental.org/~armin76/dist/${P/-bin}-xpi//${P/-bin/}-${X}.xpi )"
	IUSE="${IUSE} linguas_${X%%-*}"
done

DEPEND=""
RDEPEND="x11-libs/libXrender
	x11-libs/libXt
	x11-libs/libXmu
	x86? (
		>=x11-libs/gtk+-2.2
		=virtual/libstdc++-3.3
	)
	amd64? (
		>=app-emulation/emul-linux-x86-baselibs-1.0
		>=app-emulation/emul-linux-x86-gtklibs-1.0
		app-emulation/emul-linux-x86-compat
	)
	>=www-client/mozilla-launcher-1.41"

S=${WORKDIR}/thunderbird

for X in ${LANGS} ; do
	SRC_URI="${SRC_URI}
		linguas_${X/-/_}? ( http://dev.gentooexperimental.org/~armin76/dist/${P}-xpi/${P/-bin/}-${X}.xpi )"
	IUSE="${IUSE} linguas_${X/-/_}"
	# english is handled internally
	if [ "${#X}" == 5 ] && ! has ${X} ${NOSHORTLANGS}; then
		SRC_URI="${SRC_URI}
			linguas_${X%%-*}? ( http://dev.gentooexperimental.org/~armin76/dist/${P}-xpi/${P/-bin}-${X}.xpi )"
		IUSE="${IUSE} linguas_${X%%-*}"
	fi
done

pkg_setup() {
	# This is a binary x86 package => ABI=x86
	# Please keep this in future versions
	# Danny van Dyk <kugelfang@gentoo.org> 2005/03/26
	has_multilib_profile && ABI="x86"
}

linguas() {
	local LANG SLANG
	for LANG in ${LINGUAS}; do
		if has ${LANG} en en_US; then
			has en ${linguas} || linguas="${linguas:+"${linguas} "}en"
			continue
		elif has ${LANG} ${LANGS//-/_}; then
			has ${LANG//_/-} ${linguas} || linguas="${linguas:+"${linguas} "}${LANG//_/-}"
			continue
		elif [[ " ${LANGS} " == *" ${LANG}-"* ]]; then
			for X in ${LANGS}; do
				if [[ "${X}" == "${LANG}-"* ]] && \
					[[ " ${NOSHORTLANGS} " != *" ${X} "* ]]; then
					has ${X} ${linguas} || linguas="${linguas:+"${linguas} "}${X}"
					continue 2
				fi
			done
		fi
		ewarn "Sorry, but ${PN} does not support the ${LANG} LINGUA"
	done
}

src_unpack() {
	unpack ${A}

	linguas
	for X in ${linguas}; do
		[[ ${X} != en ]] && xpi_unpack ${P/-bin}-${X}.xpi
	done
	if [[ ${linguas} != "" ]]; then
		einfo "Selected language packs (first will be default): ${linguas}"
	fi
}

src_install() {
	declare MOZILLA_FIVE_HOME=/opt/thunderbird

	# Install thunderbird in /opt
	dodir ${MOZILLA_FIVE_HOME%/*}
	mv ${S} ${D}${MOZILLA_FIVE_HOME}

	linguas
	for X in ${linguas}; do
		[[ ${X} != en ]] && xpi_install ${WORKDIR}/${P/-bin}-${X}
	done

	local LANG=${linguas%% *}
	if [[ ${LANG} != "" && ${LANG} != "en" ]]; then
		ebegin "Setting default locale to ${LANG}"
		sed -i "s:pref(\"general.useragent.locale\", \"en-US\"):pref(\"general.useragent.locale\", \"${LANG}\"):" \
			${D}${MOZILLA_FIVE_HOME}/defaults/pref/all-thunderbird.js \
			${D}${MOZILLA_FIVE_HOME}/defaults/pref/all-l10n.js
		eend $? || die "sed failed to change locale"
	fi

	# Install /usr/bin/thunderbird-bin
	install_mozilla_launcher_stub thunderbird-bin ${MOZILLA_FIVE_HOME}

	# Install icon and .desktop for menu entry
	insinto /usr/share/pixmaps
	doins ${FILESDIR}/icon/${PN}-icon.png
	insinto /usr/share/applications
	doins ${FILESDIR}/icon/${PN}.desktop

	# revdep-rebuild entry
	insinto /etc/revdep-rebuild
	doins ${FILESDIR}/10thunderbird-bin

	# install env.d entry for libs
	doenvd ${FILESDIR}/71thunderbird-bin
}

pkg_preinst() {
	declare MOZILLA_FIVE_HOME=/opt/thunderbird

	# Remove entire installed instance to solve various
	# problems, for example see bug 27719
	rm -rf ${ROOT}${MOZILLA_FIVE_HOME}
}

pkg_postinst() {
	elog "For enigmail, please see instructions at"
	elog "  http://enigmail.mozdev.org/"

	if use amd64; then
		elog
		elog "NB: You just installed a 32-bit thunderbird"
	fi

	update_mozilla_launcher_symlinks
}

pkg_postrm() {
	update_mozilla_launcher_symlinks
}
