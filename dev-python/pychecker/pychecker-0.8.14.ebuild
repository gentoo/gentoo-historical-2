# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-python/pychecker/pychecker-0.8.14.ebuild,v 1.7 2005/07/02 23:11:06 kloeri Exp $

inherit distutils

DESCRIPTION="tool for finding common bugs in python source code"
SRC_URI="mirror://sourceforge/pychecker/${P}.tar.gz"
HOMEPAGE="http://pychecker.sourceforge.net/"
SLOT="0"
KEYWORDS="alpha amd64 ~ppc sparc x86"
LICENSE="BSD"
IUSE=""
DEPEND="virtual/python"
DOCS="pycheckrc TODO"

