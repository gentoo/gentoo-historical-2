# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-vcs/bzr-rewrite/bzr-rewrite-0.6.0.ebuild,v 1.3 2010/07/27 21:22:05 arfrever Exp $

EAPI="3"
PYTHON_DEPEND="2"
SUPPORT_PYTHON_ABIS="1"
RESTRICT_PYTHON_ABIS="3.*"

inherit distutils

DESCRIPTION="Bazaar plugin that adds support for rebasing, similar to the functionality in git"
HOMEPAGE="http://bazaar-vcs.org/Rebase"
SRC_URI="http://launchpad.net/bzr-rewrite/trunk/${PV}/+download/${P}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND=">=dev-vcs/bzr-1.14
	!dev-vcs/bzr-rebase"
RDEPEND="${DEPEND}
	!<dev-vcs/bzr-svn-0.6"
