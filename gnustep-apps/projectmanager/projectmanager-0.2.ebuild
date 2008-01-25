# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/gnustep-apps/projectmanager/projectmanager-0.2.ebuild,v 1.3 2008/01/25 17:52:49 opfer Exp $

inherit gnustep-2

MY_PN="ProjectManager"
S="${WORKDIR}/${MY_PN}-${PV}"

DESCRIPTION="ProjectManager is another IDE for GNUstep"
HOMEPAGE="http://home.gna.org/pmanager/"
SRC_URI="http://download.gna.org/pmanager/${PV}/${MY_PN}-${PV}.tar.bz2"

KEYWORDS="~amd64 ~ppc x86"
LICENSE="GPL-2"
SLOT="0"

DEPEND="gnustep-apps/keyarcher
	gnustep-apps/plconv
	gnustep-libs/highlighterkit
	gnustep-libs/wizardkit"
RDEPEND="${DEPEND}"

src_unpack() {
	unpack ${A}
	cd "${S}"

	epatch "${FILESDIR}"/${P}-gui12.patch
	epatch "${FILESDIR}"/${P}-pathdomainmask.patch
	epatch "${FILESDIR}"/${P}-gnustep-base1.15.patch
}
