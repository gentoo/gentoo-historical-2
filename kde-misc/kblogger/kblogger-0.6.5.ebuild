# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/kde-misc/kblogger/kblogger-0.6.5.ebuild,v 1.2 2008/02/18 22:34:46 ingmar Exp $

inherit kde versionator

MY_P="${P/_beta/beta}"
S="${WORKDIR}/${MY_P}"

DESCRIPTION="Blogging applet for KDE"
HOMEPAGE="http://kblogger.pwsp.net/"
SRC_URI="http://kblogger.pwsp.net/files/${MY_P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND="|| ( =kde-base/kicker-3.5* =kde-base/kdebase-3.5* )"
RDEPEND="${DEPEND}"

src_unpack() {
	kde_src_unpack
	rm -f "${S}/configure"
}
