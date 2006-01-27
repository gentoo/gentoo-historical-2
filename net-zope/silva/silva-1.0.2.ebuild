# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-zope/silva/silva-1.0.2.ebuild,v 1.3 2006/01/27 02:45:05 vapier Exp $

inherit zproduct

DESCRIPTION="Web based CMS for creating publications for the web, paper, and other media"
HOMEPAGE="http://www.infrae.com/download/Silva"
SRC_URI="${HOMEPAGE}/${PV}/Silva-${PV}.tgz"

LICENSE="ZPL"
KEYWORDS="~x86"

RDEPEND=">=net-zope/annotations-0.4.3
	>=net-zope/proxyindex-1.2
	>=net-zope/silvaviews-0.9
	>=net-zope/silvametadata-0.8
	>=net-zope/sprout-0.5
	>=net-zope/parsedxml-1.4
	>=net-zope/formulator-1.6.2
	>=net-zope/xmlwidgets-0.10.3
	>=net-zope/filesystemsite-1.4.1"

ZPROD_LIST="Silva"
