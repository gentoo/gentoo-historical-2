# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-text/sword-modules/sword-modules-20041209.ebuild,v 1.2 2005/01/01 16:37:07 eradicator Exp $

CROSSWIREFTP="http://www.crosswire.org/ftpmirror/pub/sword/packages/rawzip"
DESCRIPTION="a collection of modules for the sword project"
HOMEPAGE="http://www.crosswire.org/sword/"
SRC_URI="${CROSSWIREFTP}/KJV.zip
	${CROSSWIREFTP}/StrongsGreek.zip
	${CROSSWIREFTP}/StrongsHebrew.zip
	${CROSSWIREFTP}/ASV.zip
	${CROSSWIREFTP}/AKJV.zip
	${CROSSWIREFTP}/ISBE.zip
	${CROSSWIREFTP}/ISV.zip
	${CROSSWIREFTP}/WebstersDict.zip
	${CROSSWIREFTP}/KJVD.zip
	${CROSSWIREFTP}/SME.zip
	${CROSSWIREFTP}/Robinson.zip
	${CROSSWIREFTP}/WEB.zip
	${CROSSWIREFTP}/Packard.zip
	${CROSSWIREFTP}/Vulgate.zip
	${CROSSWIREFTP}/Josephus.zip
	${CROSSWIREFTP}/Jubilee2000.zip
	${CROSSWIREFTP}/MHC.zip
	offensive? (mirror://gentoo/BoM.zip
		mirror://gentoo/Jasher.zip
		mirror://gentoo/Quran.zip)
	intl? (${CROSSWIREFTP}/GerElb.zip
		${CROSSWIREFTP}/GerElb1871.zip
		${CROSSWIREFTP}/GerLut.zip
		${CROSSWIREFTP}/GerLut1545.zip
		${CROSSWIREFTP}/GerSch.zip
		${CROSSWIREFTP}/SpaRV.zip
		${CROSSWIREFTP}/FreLSG.zip
		${CROSSWIREFTP}/ItaRive.zip)"
# must wait for the betamodules to return.
#	http://www.crosswire.org/ftpmirror/pub/sword/betamodules/win/QuranShakir.zip

RESTRICT="nomirror"
LICENSE="freedist"
SLOT="0"
KEYWORDS="~x86 ~ppc ~amd64"
IUSE="offensive intl"

S=${WORKDIR}

RDEPEND="app-text/sword"
DEPEND="${RDEPEND}
	app-arch/unzip"

src_unpack() {
	# first, extract the easy ones
	unpack KJV.zip > /dev/null
	unpack StrongsGreek.zip > /dev/null
	unpack StrongsHebrew.zip > /dev/null
	unpack ASV.zip > /dev/null
	unpack AKJV.zip > /dev/null
	unpack ISBE.zip > /dev/null
	unpack ISV.zip > /dev/null
	unpack WebstersDict.zip > /dev/null
	unpack KJVD.zip > /dev/null
	unpack SME.zip > /dev/null
	unpack Robinson.zip > /dev/null
	unpack WEB.zip > /dev/null
	unpack Packard.zip > /dev/null
	unpack Vulgate.zip > /dev/null
	unpack Josephus.zip > /dev/null
	unpack Jubilee2000.zip > /dev/null
	unpack MHC.zip > /dev/null

	if use intl; then
		unpack GerElb.zip > /dev/null
		unpack GerElb1871.zip > /dev/null
		unpack GerLut.zip > /dev/null
		unpack GerLut1545.zip > /dev/null
		unpack GerSch.zip > /dev/null
		unpack SpaRV.zip > /dev/null
		unpack FreLSG.zip > /dev/null
		unpack ItaRive > /dev/null
	fi

	if use offensive; then
		unpack BoM.zip > /dev/null
		unpack Jasher.zip > /dev/null
		# uh oh, the quran is only availabe for windows; extract the data
		unpack Quran.zip > /dev/null
		unzip ${S}/data.zip > /dev/null
#		unpack QuranShakir.zip > /dev/null
#		unzip ${S}/data.zip > /dev/null
	fi
}

src_compile() {
	einfo "Nothing to compile."
}

src_install () {
	dodir /usr/share/sword/modules || die
	cp -a ${S}/modules/* ${D}/usr/share/sword/modules/ || die
	dodir /usr/share/sword/mods.d || die
	cp ${S}/mods.d/* ${D}/usr/share/sword/mods.d/ || die

	# there are windows-only modules in the offensive flag that put
	# config files into /newmods instead of /mods.d
	if use offensive; then
		cp ${S}/newmods/* ${D}/usr/share/sword/mods.d/ || die
	fi
}

pkg_postinst() {
	echo
	einfo "You should now have modules for The SWORD Project."
	einfo "You can download more modules from the SWORD homepage:"
	einfo "  http://www.crosswire.org/sword/"
	if ! use offensive; then
		echo
		einfo "You do not have the offensive USE flag enabled."
		einfo "Questionable texts were not installed. To install them,"
		einfo "USE=\"offensive\" emerge ${PN}"
	fi
	if ! use intl; then
		echo
		einfo "To enable different languages of selected texts contained"
		einfo "in this ebuild,"
		einfo "USE=\"intl\" emerge ${PN}"
	fi
}
