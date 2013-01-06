# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-misc/dropbox-cli/dropbox-cli-1-r1.ebuild,v 1.1 2013/01/06 00:34:02 hasufell Exp $

EAPI=5

PYTHON_COMPAT=( python2_6 python2_7 )

inherit python-r1

DESCRIPTION="Cli interface for dropbox daemon (python)"
HOMEPAGE="http://www.dropbox.com/"
SRC_URI="https://dev.gentoo.org/~hasufell/distfiles/${P}.py.xz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND="net-misc/dropbox
	virtual/python-argparse"

S=${WORKDIR}

src_install() {
	newbin ${P}.py ${PN}
	python_replicate_script "${D}"/usr/bin/${PN}
}
