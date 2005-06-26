# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-www/adobesvg/adobesvg-3.01.ebuild,v 1.1 2005/06/26 10:34:07 dragonheart Exp $

inherit nsplugins

MY_BV=88
MY_PV=${PV}x${MY_BV}
DESCRIPTION="Scalable Vector Graphics plugin"
HOMEPAGE="http://www.adobe.com/svg/main.html"
SRC_URI="http://download.adobe.com/pub/adobe/magic/svgviewer/linux/3.x/3.01x${MY_BV}/en/${PN}-${MY_PV}-linux-i386.tar.gz"

LICENSE="Adobe"
SLOT="0"
KEYWORDS="-* ~x86"
IUSE=""

S="${WORKDIR}/${PN}-3.01"

src_install() {
	insinto /usr/lib/adobesvg
	doins *.so LICENSE.txt

	dodir /opt/netscape/plugins
	dosym /usr/lib/adobesvg/libNPSVG3.so /opt/netscape/plugins/libNPSVG3.so
	inst_plugin /usr/lib/adobesvg/libNPSVG3.so
	#inst_plugin /opt/netscape/plugins/libNPSVG3.so

	dohtml -A svg *.html *.svg
}
