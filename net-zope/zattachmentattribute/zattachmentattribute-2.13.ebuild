# Copyright 1999-2004 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-zope/zattachmentattribute/zattachmentattribute-2.13.ebuild,v 1.2 2004/10/14 19:59:49 dholm Exp $

inherit zproduct

DESCRIPTION="ZAttachmentAttribute simplifies the use of simple attachment files with user-created Zope products."
HOMEPAGE="http://ingeniweb.sourceforge.net/"
SRC_URI="mirror://sourceforge/ingeniweb/ZAttachmentAttribute-${PV}.tar.gz"
LICENSE="ZPL"
KEYWORDS="~x86 ~ppc"
IUSE=""

DEPEND=">=net-zope/cmf-1.4.2-r1
		>=net-zope/zope-2.7.0
		app-admin/zprod-manager"

ZPROD_LIST="ZAttachmentAttribute"

pkg_postinst()
{
	zproduct_pkg_postinst
	einfo "Please consider also emerge zaaplugins package which contains usefull plugins."
}

