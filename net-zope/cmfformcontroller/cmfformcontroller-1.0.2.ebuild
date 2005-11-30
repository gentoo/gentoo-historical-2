# Copyright 1999-2004 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-zope/cmfformcontroller/cmfformcontroller-1.0.2.ebuild,v 1.1.1.1 2005/11/30 10:11:05 chriswhite Exp $

inherit zproduct

DESCRIPTION="CMFFormController replaces the portal_form form validation mechanism from Plone."
HOMEPAGE="http://sf.net/projects/collective"
SRC_URI="mirror://sourceforge/collective/CMFFormController-${PV}.tgz"
LICENSE="ZPL"
KEYWORDS="~x86 ~ppc"
SLOT="0"
IUSE=""

RDEPEND="${RDEPEND}
	net-zope/cmf"

ZPROD_LIST="CMFFormController"
