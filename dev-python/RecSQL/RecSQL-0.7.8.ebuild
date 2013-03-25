# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-python/RecSQL/RecSQL-0.7.8.ebuild,v 1.2 2013/03/25 11:44:16 alexxy Exp $

EAPI=5

PYTHON_COMPAT=( python{2_5,2_6,2_7} )

if [[ $PV = *9999* ]]; then
	scm_eclass=git-2
	EGIT_REPO_URI="
		git://github.com/orbeckst/${PN}.git
		https://github.com/orbeckst/${PN}.git"
	SRC_URI=""
	KEYWORDS=""
else
	scm_eclass=vcs-snapshot
	SRC_URI="https://github.com/orbeckst/${PN}/archive/release-${PV}.tar.gz -> ${P}.tar.gz"
	KEYWORDS="~amd64 ~x86"
fi

inherit eutils distutils-r1 ${scm_eclass}

DESCRIPTION="RecSQL - simple SQL analysis of python records"
HOMEPAGE="http://orbeckst.github.com/RecSQL/"
LICENSE="GPL-3"
SLOT="0"
IUSE=""

DEPEND="
	dev-lang/python[sqlite]
	dev-python/numpy"
RDEPEND="${DEPEND}"
