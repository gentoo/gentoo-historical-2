# Copyright 1999-2004 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-zope/plone/plone-1.0.3.ebuild,v 1.9 2004/06/25 01:23:50 agriffis Exp $

inherit zproduct
S="${WORKDIR}/CMFPlone-${PV}"

DESCRIPTION="A Zope Content Management System, based on Zope CMF."
HOMEPAGE="http://plone.org"
SRC_URI="mirror://sourceforge/plone/CMFPlone${PV}.tar.gz"
LICENSE="GPL-2"
KEYWORDS="x86"
RDEPEND="=net-zope/cmf-1.3*
	>=net-zope/formulator-1.2.0
	${RDEPEND}"

ZPROD_LIST="CMFPlone DCWorkflow"
MYDOC="docs/NavigationTool.txt docs/SiteTypes.txt ${MYDOC}"

src_install()
{
	rm -R Formulator/
	zproduct_src_install all
}

# Since i18n isn't a product folder, leaving it in $ZP_DIR/$PF.

pkg_postinst()
{
	zproduct_pkg_postinst
	einfo "---> NOTE: i18n folder location: ${ZP_DIR}/${PF}"
}
