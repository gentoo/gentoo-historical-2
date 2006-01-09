# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-plugins/vdr-graphlcd/vdr-graphlcd-0.1.2_pre6-r1.ebuild,v 1.2 2006/01/09 21:11:44 hd_brummy Exp $

inherit eutils vdr-plugin

MY_PV="${PV/_/-}"
MY_P="${PN}-${MY_PV}"

DESCRIPTION="VDR Graphical LCD PlugIn"
HOMEPAGE="http://www.powarman.de"
SRC_URI="http://home.arcor.de/andreas.regel/files/graphlcd/${MY_P}.tgz"

KEYWORDS="~x86 ~amd64"
SLOT="0"
LICENSE="GPL-2"
IUSE="truetype"

S=${WORKDIR}/${VDRPLUGIN}-${MY_PV}

DEPEND=">=media-video/vdr-1.2.6
		>=app-misc/graphlcd-base-${PV}
		!sys-apps/graphlcd-base"

# DO NOT remove "!sys-apps/graphlcd-base" from DEPEND !!!
# It will fix a conflict with ebuilds in Gentoo.de OVERLAY CVS

src_unpack() {

	vdr-plugin_src_unpack

	cd ${S}

	sed -i "s:/usr/local:/usr:" Makefile
}

src_install() {

	vdr-plugin_src_install

	insopts -m0644 -ovdr -gvideo

	insinto /usr/share/vdr/${VDRPLUGIN}/logos
	doins -r ${VDRPLUGIN}/logos/*

	insinto /usr/share/vdr/${VDRPLUGIN}/fonts
	doins ${VDRPLUGIN}/fonts/*.fnt

	if use truetype; then
		for font in /usr/share/fonts/corefonts/*.ttf; do
			einfo ${font}
			dosym ${font} /usr/share/vdr/graphlcd/fonts
		done
	fi

	insinto /etc/vdr/plugins/${VDRPLUGIN}
	doins ${VDRPLUGIN}/logonames.alias.*
	doins ${VDRPLUGIN}/fonts.conf.*

	dosym /usr/share/vdr/${VDRPLUGIN}/fonts /etc/vdr/plugins/${VDRPLUGIN}/fonts
	dosym /usr/share/vdr/${VDRPLUGIN}/logos /etc/vdr/plugins/${VDRPLUGIN}/logos
	dosym /etc/graphlcd.conf /etc/vdr/plugins/${VDRPLUGIN}/graphlcd.conf

	if has_version ">=media-video/vdr-1.3.2" ; then
		dosym /etc/vdr/plugins/${VDRPLUGIN}/logonames.alias.1.3 /etc/vdr/plugins/${VDRPLUGIN}/logonames.alias
	else
		dosym /etc/vdr/plugins/${VDRPLUGIN}/logonames.alias.1.2 /etc/vdr/plugins/${VDRPLUGIN}/logonames.alias
	fi
}

pkg_preinstall() {

	if [[ -e /etc/vdr/plugins/graphlcd/fonts ]] && [[ ! -L /etc/vdr/plugins/graphlcd/fonts ]] ||
	[[ -e /etc/vdr/plugins/graphlcd/logos ]] && [[ ! -L /etc/vdr/plugins/graphlcd/logos ]] ;then

		einfo "Remove wrong DIR in /etc/vdr/plugins/graphlcd from prior install"
		einfo "Press CTRL+C to abbort"
		epause
		rmdir -R /etc/vdrplugins/graphlcd/{fonts,logos}
	fi
}

pkg_postinst() {

	vdr-plugin_pkg_postinst

	einfo "Add additional options in /etc/conf.d/vdr.graphlcd"
	einfo
	einfo "Please copy or link one of the supplied fonts.conf.*"
	einfo "files in /etc/vdr/plugins/graphlcd/ to"
	einfo "/etc/vdr/plugins/graphlcd/fonts.conf"
}

