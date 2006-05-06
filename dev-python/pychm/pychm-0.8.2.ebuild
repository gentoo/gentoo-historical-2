# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-python/pychm/pychm-0.8.2.ebuild,v 1.3 2006/05/06 00:16:55 wormo Exp $

inherit distutils

DESCRIPTION="Python bindings for the chmlib library"
HOMEPAGE="http://gnochm.sourceforge.net/pychm.html"
SRC_URI="mirror://sourceforge/gnochm/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86 ~ppc"
IUSE=""

DEPEND="virtual/python
	app-doc/chmlib"

PYTHON_MODNAME="chm"
DOCS="NEWS"

