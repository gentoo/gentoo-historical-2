# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-python/ipaddr/ipaddr-2.1.9.ebuild,v 1.1 2011/11/04 21:12:51 maksbotan Exp $

EAPI=3

SUPPORT_PYTHON_ABIS=1
PYTHON_DEPEND="2:2.6"

inherit distutils

DESCRIPTION="Python IP address manipulation library"
HOMEPAGE="http://code.google.com/p/ipaddr-py/"
SRC_URI="http://ipaddr-py.googlecode.com/files/${P}.tar.gz"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~x86 ~amd64"
IUSE=""

DEPEND=""
RDEPEND="${DEPEND}"
DOCS=(PKG-INFO README RELEASENOTES)
