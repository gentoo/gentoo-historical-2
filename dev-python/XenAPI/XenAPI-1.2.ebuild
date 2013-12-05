# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-python/XenAPI/XenAPI-1.2.ebuild,v 1.1 2013/12/05 05:15:43 idella4 Exp $

EAPI=5
PYTHON_COMPAT=( python2_7 )

inherit distutils-r1

DESCRIPTION="XenAPI SDK, for communication with Citrix XenServer and Xen Cloud Platform."
HOMEPAGE="http://community.citrix.com/display/xs/Download+SDKs"
SRC_URI="mirror://pypi/X/${PN}/${P}.tar.gz"

LICENSE="LGPL-2"
SLOT="0"
KEYWORDS="~amd64"
IUSE=""

DEPEND=""
RDEPEND="${DEPEND}"

