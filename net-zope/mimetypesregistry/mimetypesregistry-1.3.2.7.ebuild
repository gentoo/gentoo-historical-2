# Copyright 1999-2004 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-zope/mimetypesregistry/mimetypesregistry-1.3.2.7.ebuild,v 1.1 2004/12/04 20:12:15 radek Exp $

inherit zproduct

MY_P=MimetypesRegistry-1.3.2-7
MASTER_PN=archetypes

DESCRIPTION="Mimetypes Registry for Archetypes and PortalTransforms used in Plone."
WEBPAGE="http://www.sourceforge.net/projects/${MASTER_PN}"
SRC_URI="mirror://sourceforge/${MASTER_PN}/${MY_P}.tar.gz"
LICENSE="GPL-2"
KEYWORDS="~x86 ~ppc"
IUSE=""
SLOT="1.3"

RDEPEND=">=net-zope/cmf-1.4.7"

ZPROD_LIST="MimetypesRegistry"

src_install()
{
	zproduct_src_install all
}
