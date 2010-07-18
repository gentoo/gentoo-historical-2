# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/mail-filter/pypolicyd-spf/pypolicyd-spf-0.8.0.ebuild,v 1.1 2010/07/18 08:47:08 dragonheart Exp $


EAPI="3"
#PYTHON_DEPEND="*"
SUPPORT_PYTHON_ABIS="1"

inherit distutils eutils versionator

DESCRIPTION="Python based policy daemon for Postfix SPF checking"
SRC_URI="http://launchpad.net/pypolicyd-spf/$(get_version_component_range 1-2)/${PV}/+download/${P}.tar.gz"
HOMEPAGE="https://launchpad.net/pypolicyd-spf"

IUSE=""
SLOT="0"
LICENSE="GPL-2"
KEYWORDS="~amd64 ~x86"

DEPEND=">=dev-python/pyspf-2.0.3"


src_prepare() {
	sed -i -e 's/[\xc2\xa9]//g' -e 's/FL/F/g'  policydspfsupp.py policydspfuser.py policyd-spf
	epatch "${FILESDIR}"/0.8.0-2to3.patch
	distutils_src_prepare

}

