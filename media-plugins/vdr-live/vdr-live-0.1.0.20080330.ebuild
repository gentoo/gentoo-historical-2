# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-plugins/vdr-live/vdr-live-0.1.0.20080330.ebuild,v 1.1 2008/03/30 21:04:34 zzam Exp $

inherit vdr-plugin versionator

MY_PV=$(get_version_component_range 4)
MY_P="${PN}-${MY_PV}"

DESCRIPTION="VDR Plugin: Web Access To Settings"
HOMEPAGE="http://live.vdr-developer.org"
#SRC_URI="http://live.vdr-developer.org/downloads/${MY_PP}.tar.gz"
SRC_URI="mirror://gentoo/${MY_P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~x86 ~amd64"
IUSE=""

DEPEND="media-video/vdr
	>=dev-libs/boost-1.33.0
	dev-libs/tntnet
	>=dev-libs/cxxtools-1.4.3"

S="${WORKDIR}/${VDRPLUGIN}"

src_install() {
	vdr-plugin_src_install

	cd "${S}/live"
	insinto /etc/vdr/plugins/live
	doins -r *

	chown vdr:vdr -R "${D}"/etc/vdr/plugins/live
}

pkg_postinst() {
	vdr-plugin_pkg_postinst

	elog "To be able to use all functions of vdr-live"
	elog "you should emerge and enable vdr-epgsearch"
	elog
	elog "\temerge vdr-epgsearch"
	elog "\teselect vdr-plugin enable epgsearch"
}

