# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-zope/cmfquickinstallertool/cmfquickinstallertool-1.5.0.ebuild,v 1.3 2005/03/19 17:24:17 weeve Exp $

inherit zproduct

DESCRIPTION="Makes it easy to install cmf/plone products."
HOMEPAGE="http://www.sf.net/projects/collective/"
SRC_URI="mirror://sourceforge/collective/CMFQuickInstallerTool-${PV}.tgz"
LICENSE="GPL-2"
KEYWORDS="x86 ppc ~sparc"
IUSE=""
RDEPEND=">=net-zope/cmf-1.3
	${RDEPEND}"

ZPROD_LIST="CMFQuickInstallerTool"
