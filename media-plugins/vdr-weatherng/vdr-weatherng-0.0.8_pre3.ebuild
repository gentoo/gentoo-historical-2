# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-plugins/vdr-weatherng/vdr-weatherng-0.0.8_pre3.ebuild,v 1.8 2007/09/19 16:02:31 hd_brummy Exp $

inherit vdr-plugin eutils

MY_PV="${PV/_/-}"
MY_P="${PN}-${MY_PV}"

DESCRIPTION="VDR plugin: show weather for specified place"
HOMEPAGE="http://www.vdr.glaserei-franz.de/vdrplugins.htm"
SRC_URI="mirror://vdrfiles/${PN}/${MY_P}.tgz"

LICENSE="GPL-2 stardock-images"
SLOT="0"
KEYWORDS="x86 ~amd64"
IUSE="dxr3"

DEPEND="media-libs/imlib2
	>=media-video/vdr-1.3.34"

S="${WORKDIR}/weatherng-${MY_PV}"

VDR_CONFD_FILE="${FILESDIR}/confd-0.0.8"
VDR_RCADDON_FILE="${FILESDIR}/rc-addon-0.0.8.sh"

PATCHES="${FILESDIR}/${P}-i18n-fix.diff"

pkg_setup() {
	vdr-plugin_pkg_setup

	if ! built_with_use media-libs/imlib2 jpeg gif ; then
		echo
		eerror "Please recompile media-libs/imlib2 with"
		eerror "USE=\"jpeg gif\""
		die "media-libs/imlib2 need jpeg and gif support"
	fi
}

src_unpack() {
	vdr-plugin_src_unpack

	epatch ${FILESDIR}/${P}-gentoo.diff
	epatch ${FILESDIR}/${P}-timeout.diff

	use dxr3 && epatch ${FILESDIR}/${P}-dxr3.diff
}

src_install() {
	vdr-plugin_src_install

	insinto /usr/share/vdr/weatherng/images
	doins ${S}/images/*.png

	diropts -m0755 -ovdr -gvdr
	dodir /var/vdr/${VDRPLUGIN}

	insinto  /var/vdr/${VDRPLUGIN}
	insopts -m755 -ovdr -gvdr
	doins ${S}/examples/weatherng.sh
}

pkg_postinst() {
	vdr-plugin_pkg_postinst

	echo
	elog "To display the weather for your location"
	elog "you have to find out its ID on weather.com"
	elog
	elog "Go to http://uk.weather.com/search/drilldown/ and search for your city (i.e. Herne)"
	elog "in the list of results click on the right one and then look at its URL"
	elog
	elog "It contains a code for your city"
	elog "For Herne this is GMXX0056"
	elog
	elog "Now you have to enter this code in /etc/conf.d/vdr.weatherng WEATHERNG_STATIONID(x)"
	echo
}
