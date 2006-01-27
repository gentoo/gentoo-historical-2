# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-zope/cmfphoto/cmfphoto-0.5.0.ebuild,v 1.3 2006/01/27 02:29:48 vapier Exp $

inherit zproduct

DESCRIPTION="Zope product to have photos"
HOMEPAGE="http://sourceforge.net/projects/collective/"
SRC_URI="mirror://sourceforge/collective/CMFPhoto-${PV}.tar.gz"

LICENSE="GPL-2"
KEYWORDS="~ppc x86"

RDEPEND="dev-python/imaging
	>=net-zope/cmf-1.3
	>=net-zope/plone-1.0.1"

ZPROD_LIST="CMFPhoto"

pkg_postinst() {
	zproduct_pkg_postinst
	ewarn "if you run zope on python < 2.3 make sure you have dev-python/Imgeing-21 installed."
	ewarn "Please use CMFQuickInstallerTool or read the documentation of this"
	ewarn "product for instruction on how to add this product to your CMF/Plone site."
}
