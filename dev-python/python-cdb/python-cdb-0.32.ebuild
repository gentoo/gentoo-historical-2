# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-python/python-cdb/python-cdb-0.32.ebuild,v 1.1.1.1 2005/11/30 10:10:30 chriswhite Exp $

inherit distutils

DESCRIPTION="A Python extension module for cdb"
SRC_URI="http://pilcrow.madison.wi.us/python-cdb/${P}.tar.gz"
HOMEPAGE="http://pilcrow.madison.wi.us/#pycdb"

SLOT="0"
IUSE=""
LICENSE="GPL-2"
KEYWORDS="amd64 ppc ~ppc-macos ~sparc x86"

DEPEND=">=dev-lang/python-2.2
	dev-db/cdb"
