# Copyright 2002-2003 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-zope/cmfforum/cmfforum-1.0.ebuild,v 1.1 2003/04/06 12:04:05 kutsuya Exp $

inherit zproduct

#DESCRIPTION="Makes it easy to install cmf/plone products."
HOMEPAGE="http://www.sf.net/projects/collective/"
SRC_URI="mirror://sourceforge/collective/CMFForum-${PV}.tgz"
LICENSE="ZPL"
KEYWORDS="x86 ~ppc"
RDEPEND=">=net-zope/cmf-1.3
	${RDEPEND}"

ZPROD_LIST="CMFForum" 

pkg_postinst()
{
	zproduct_pkg_postinst
	ewarn "Please read README.txt.gz for this product. This product needs to"
    ewarn "be manually added to a CMF/Plone site."
}
