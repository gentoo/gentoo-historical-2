 
# Copyright 2003 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-zope/silva/silva-0.9.1.2.ebuild,v 1.1 2003/04/06 04:16:34 kutsuya Exp $

inherit zproduct

DESCRIPTION="XML Publishing and authoring system"
HOMEPAGE="http://www.zope.org/Members/faassen/Silva"
SRC_URI="${HOMEPAGE}/Silva-${PV}.tgz"
LICENSE="ZPL"
KEYWORDS="x86 ~ppc"
RDEPEND=">=net-zope/parsedxml-1.3.1
         >=net-zope/formulator-1.3.1
         >=net-zope/xmlwidgets-0.8.4
         >=net-zope/filesystemsite-1.2
         ${RDEPEND}"

ZPROD_LIST="Silva"
