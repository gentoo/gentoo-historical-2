# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-news/rawdog/rawdog-2.12.ebuild,v 1.7 2009/07/17 18:15:22 nixnut Exp $

NEED_PYTHON=2.2
inherit distutils

DESCRIPTION="Rawdog - RSS Aggregator Without Delusions Of Grandeur"
HOMEPAGE="http://offog.org/code/rawdog.html"
SRC_URI="http://offog.org/files/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="alpha amd64 hppa ia64 ppc s390 sparc x86"
IUSE=""

DEPEND=""
RDEPEND=""

DOCS="NEWS PLUGINS config style.css"
PYTHON_MODNAME="rawdoglib"
