# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/kde-misc/kblogger/kblogger-0.6.ebuild,v 1.1 2006/05/30 01:42:08 flameeyes Exp $

inherit kde

MY_P="${P/_beta/beta}"
S="${WORKDIR}/${MY_P}"

DESCRIPTION="Blogging applet for KDE"
HOMEPAGE="http://kblogger.pwsp.net/"
SRC_URI="http://kblogger.pwsp.net/files/${MY_P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64"
IUSE=""

DEPEND=""
RDEPEND=""

src_unpack() {
	kde_src_unpack
	rm -f "${S}/configure"
}
