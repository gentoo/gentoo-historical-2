# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-text/wklej/wklej-0.1.3.ebuild,v 1.2 2008/09/30 02:05:08 darkside Exp $

DESCRIPTION="A wklej.org submitter"
HOMEPAGE="http://wklej.org"
SRC_URI="http://wklej.org/m/apps/wklej-${PV}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ~x86"
IUSE=""

DEPEND="${RDEPEND}"
RDEPEND="dev-lang/python"

src_install() {
	dobin "${WORKDIR}"/${P}.py
	dosym ${P}.py /usr/bin/${PN}
}
