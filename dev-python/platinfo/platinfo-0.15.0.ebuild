# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-python/platinfo/platinfo-0.15.0.ebuild,v 1.1 2011/12/20 15:36:56 aidecoe Exp $

EAPI=4

inherit distutils

DESCRIPTION="Determines and returns consistent names for platforms"
HOMEPAGE="http://code.google.com/p/platinfo/"
SRC_URI="http://platinfo.googlecode.com/files/${P}.zip"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"
IUSE=""

DEPEND=""
RDEPEND="${DEPEND}"
