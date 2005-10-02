# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-python/pychecker/pychecker-0.8.14.ebuild,v 1.10 2005/10/02 14:15:54 agriffis Exp $

inherit distutils

DESCRIPTION="tool for finding common bugs in python source code"
SRC_URI="mirror://sourceforge/pychecker/${P}.tar.gz"
HOMEPAGE="http://pychecker.sourceforge.net/"
SLOT="0"
KEYWORDS="alpha amd64 ia64 ppc sparc x86"
LICENSE="BSD"
IUSE=""
DEPEND="virtual/python"
DOCS="pycheckrc TODO"

