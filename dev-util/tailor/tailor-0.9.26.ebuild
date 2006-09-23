# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-util/tailor/tailor-0.9.26.ebuild,v 1.1 2006/09/23 23:49:07 marienz Exp $

inherit distutils

DESCRIPTION="tailor is a tool to migrate changesets between version control systems"
HOMEPAGE="http://www.darcs.net/DarcsWiki/Tailor"
SRC_URI="http://darcs.arstecnica.it/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86 ~x86-fbsd"
IUSE=""

DEPEND=">=dev-lang/python-2.4"

PYTHON_MODNAME="vcpx"
