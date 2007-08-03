# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-util/qgit/qgit-1.5.6.ebuild,v 1.4 2007/08/03 18:07:50 angelos Exp $

inherit qt3

MY_PV=${PV//_/}
MY_P=${PN}-${MY_PV}

DESCRIPTION="GUI interface for git/cogito SCM"
HOMEPAGE="http://digilander.libero.it/mcostalba/"
SRC_URI="mirror://sourceforge/${PN}/${MY_P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ~ppc ppc64 x86"
IUSE=""

DEPEND="=x11-libs/qt-3*"
RDEPEND="${DEPEND}
	>=dev-util/git-1.5"

S="${WORKDIR}/${MY_P}"

src_install() {
	dobin src/qgit
	dodoc README ChangeLog
}
