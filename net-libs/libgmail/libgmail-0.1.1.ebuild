# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-libs/libgmail/libgmail-0.1.1.ebuild,v 1.2 2005/09/17 14:15:38 mkay Exp $

inherit distutils

DESCRIPTION="Python bindings to access Google's gmail service"
HOMEPAGE="http://libgmail.sourceforge.net/"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~x86 ~amd64 ~ppc"

IUSE=""

DEPEND="dev-python/logging
	virtual/python"

