# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-python/testtools/testtools-0.9.2.ebuild,v 1.3 2010/02/01 21:18:53 jer Exp $

EAPI=2
NEED_PYTHON=2.4

inherit distutils versionator

SERIES=$(get_version_component_range 1-2)

DESCRIPTION="Extensions to the Python unittest library"
HOMEPAGE="https://launchpad.net/testtools"
SRC_URI="http://launchpad.net/${PN}/${SERIES}/${PV}/+download/${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~hppa ~ppc ~x86"
IUSE=""

DEPEND=""
RDEPEND="${DEPEND}"
