# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-text/wklej/wklej-0.1.2.ebuild,v 1.1 2008/08/22 13:46:46 cla Exp $

DESCRIPTION="A wklej.org submitter"
HOMEPAGE="http://wklej.org"
SRC_URI="http://wklej.org/m/apps/wklej-${PV}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~x86 ~amd64"
IUSE=""

DEPEND="${RDEPEND}"
RDEPEND="dev-lang/python"

src_install() {
	dobin "${WORKDIR}"/${P}.py
	dosym ${P}.py /usr/bin/${PN}
}
