# Copyright 1999-2004 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-zope/zwiki/zwiki-0.36.2.ebuild,v 1.1 2004/12/18 22:22:27 batlogg Exp $

inherit zproduct

DESCRIPTION="A zope wiki-clone for easy-to-edit collaborative websites."
HOMEPAGE="http://zwiki.org"
SRC_URI="${HOMEPAGE}/releases/ZWiki-${PV}.tgz"

LICENSE="GPL-2"
KEYWORDS="~x86 ~ppc"

ZPROD_LIST="ZWiki"
MYDOC="ChangeLog GPL.txt ${MYDOC}"

IUSE=""
