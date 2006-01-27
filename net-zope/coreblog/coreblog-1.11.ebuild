# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-zope/coreblog/coreblog-1.11.ebuild,v 1.2 2006/01/27 02:30:51 vapier Exp $

inherit zproduct

NEW_PV="${PV//./-}"
DESCRIPTION="Blog/Weblog/Web Nikki system for Zope"
HOMEPAGE="http://coreblog.org/"
SRC_URI="${HOMEPAGE}/junk/COREBlog111.tgz"

LICENSE="GPL-2"
KEYWORDS="~ppc ~x86"

ZPROD_LIST="COREBlog"
