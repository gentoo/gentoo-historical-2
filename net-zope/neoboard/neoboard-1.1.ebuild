# Copyright 1999-2003 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-zope/neoboard/neoboard-1.1.ebuild,v 1.4 2003/09/11 01:27:47 msterret Exp $

inherit zproduct
P_NEW="NeoBoard-${PV}"

DESCRIPTION="Threaded message boards w/articles, attachments, & i18n."
HOMEPAGE="http://www.zoper.net/"
SRC_URI="${HOMEPAGE}/Downloads/${P_NEW}.tar.gz"
LICENSE="GPL-2"
KEYWORDS="x86 ppc"
RDEPEND="net-zope/neoportallibrary
	${RDEPEND}"

ZPROD_LIST="NeoBoard"

src_unpack()
{
	unpack ${A}
	mv ${S}/${P_NEW} ${S}/NeoBoard
}

pkg_postinst()
{
	zproduct_pkg_postinst
	ewarn "There are three different ways to add this product to your"
	ewarn "Zope/CMF/Plone site. Please consult the documentation."
}
