# Copyright 1999-2003 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-fonts/mikachan-font/mikachan-font-8.8.ebuild,v 1.1 2003/07/26 21:40:36 usata Exp $

IUSE=""

MY_PN="${PN/-/}"

DESCRIPTION="Mikachan Japanese TrueType fonts"
SRC_URI="mirror://sourceforge.jp/mikachan/2418/${MY_PN}-${PV}.tar.bz2
	mirror://sourceforge.jp/mikachan/2419/${MY_PN}P-${PV}.tar.bz2
	mirror://sourceforge.jp/mikachan/2420/${MY_PN}PB-${PV}.tar.bz2
	mirror://sourceforge.jp/mikachan/2421/${MY_PN}PS-${PV}.tar.bz2"
HOMEPAGE="http://mikachan-font.com/"

KEYWORDS="~x86"
LICENSE="free-noncomm"
SLOT="0"

DEPEND=""

S="${WORKDIR}"

FONTDIR="/usr/share/fonts/ttf/ja/mikachan/"

src_install () {
	insopts -m0644
	insinto ${FONTDIR}

	# To merge fonts.scale files
	echo 24 > fonts.scale

	for f in "${MY_PN}" "${MY_PN}P" "${MY_PN}PB" "${MY_PN}PS" ; do
		cd ${WORKDIR}/${f}-${PV}
		doins  fonts/*.ttf
		newdoc COPYRIGHT	COPYRIGHT.${f}
		newdoc COPYRIGHT.ja	COPYRIGHT.ja.${f}
		newdoc README		README.${f}
		newdoc README.ja	README.ja.${f}
		newdoc ChangeLog	ChangeLog.${f}
		tail -6 fontsconf/fonts.scale.${f} >> ${WORKDIR}/fonts.scale
	done

	cd ${WORKDIR}
	doins  fonts.scale
	newins fonts.scale fonts.dir
}

pkg_postinst() {
	einfo "You need you add following line into 'Section \"Files\"' in"
	einfo "XF86Config and reboot X Window System, to use these fonts."
	einfo ""
	einfo "\t FontPath \"${FONTDIR}\""
	einfo ""
}

pkg_postrm(){
	einfo "You need you remove following line in 'Section \"Files\"' in"
	einfo "XF86Config, to unmerge this package completely."
	einfo ""
	einfo "\t FontPath \"${FONTDIR}\""
	einfo ""
}
