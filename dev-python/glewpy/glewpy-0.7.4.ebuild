# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-python/glewpy/glewpy-0.7.4.ebuild,v 1.2 2007/02/13 22:04:05 armin76 Exp $

inherit distutils

DESCRIPTION="Python bindings for the OpenGL Extension Wrangler Library"
HOMEPAGE="http://glewpy.sourceforge.net"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.gz"

LICENSE="PYTHON"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND="dev-python/pyrex
	media-libs/glew"

PYTHON_MODNAME="glew"

