# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-python/cfgparse/cfgparse-1.2-r1.ebuild,v 1.3 2009/02/15 22:02:28 patrick Exp $

inherit distutils versionator

MY_PN="v0$(get_major_version)_0$(get_version_component_range 2-2)"
S=${WORKDIR}/${PN}-${MY_PN}

DESCRIPTION="Config File parser for Python"
HOMEPAGE="http://cfgparse.sourceforge.net"
SRC_URI="mirror://sourceforge/cfgparse/${PN}-${MY_PN}.tar.gz"

LICENSE="PSF-2.3"
SLOT="0"
KEYWORDS="~amd64 ~ia64 ~x86"
IUSE=""

DEPEND=""
RDEPEND=">=dev-lang/python-2.4"

src_install() {
	distutils_src_install

	dodoc README.txt docs/cfgparse*
	dohtml docs/cfgparse/*
}
