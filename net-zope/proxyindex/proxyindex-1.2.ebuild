# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-zope/proxyindex/proxyindex-1.2.ebuild,v 1.1.1.1 2005/11/30 10:11:07 chriswhite Exp $

inherit zproduct

DESCRIPTION="ProxyIndex is a plugin to zope catalog index."
HOMEPAGE="http://www.infrae.com/download/ProxyIndex"
SRC_URI="${HOMEPAGE}/${PV}/ProxyIndex-${PV}.tgz"
LICENSE="ZPL"
KEYWORDS="x86 ~ppc ~amd64"
IUSE=""

ZPROD_LIST="ProxyIndex"
