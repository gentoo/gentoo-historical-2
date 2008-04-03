# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-python/hachoir-parser/hachoir-parser-1.1.ebuild,v 1.1 2008/04/03 16:08:35 cedk Exp $

NEED_PYTHON=2.4

inherit distutils

DESCRIPTION="a package of most common file format parsers written using
hachoir-core"
HOMEPAGE="http://hachoir.org/wiki/hachoir-parser"
SRC_URI="http://cheeseshop.python.org/packages/source/h/${PN}/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~x86"
IUSE=""

DEPEND=""
RDEPEND=">=dev-python/hachoir-core-1.1"

PYTHON_MODNAME="hachoir_parser"
