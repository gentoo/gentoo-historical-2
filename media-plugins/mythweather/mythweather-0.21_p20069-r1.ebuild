# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-plugins/mythweather/mythweather-0.21_p20069-r1.ebuild,v 1.1 2009/11/10 15:58:40 cardoe Exp $

EAPI=2
inherit qt3 mythtv-plugins

DESCRIPTION="Weather forecast module for MythTV."
IUSE=""
KEYWORDS="~amd64 ~ppc ~x86"

DEPEND="dev-perl/DateManip
	dev-perl/ImageSize
	dev-perl/SOAP-Lite
	dev-perl/XML-Simple
	dev-perl/XML-Parser
	dev-perl/XML-SAX"

src_prepare() {
	epatch "${FILESDIR}/${P}-nws-parse-fix.patch"
}

src_install() {
	mythtv-plugins_src_install

	# correct permissions so MythWeather is actually usable
	fperms 755 /usr/share/mythtv/mythweather/scripts/*/*.pl
}
