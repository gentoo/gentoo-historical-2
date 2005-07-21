# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-misc/mepl/mepl-0.45.ebuild,v 1.8 2005/07/21 17:21:57 dholm Exp $

DESCRIPTION="Self-employed-mode software for 3COM/USR message modems"
HOMEPAGE="http://www.hof-berlin.de/mepl/"
SRC_URI="http://www.hof-berlin.de/mepl/mepl${PV}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~ppc x86"
IUSE=""

DEPEND="virtual/libc"

S=${WORKDIR}/${PN}${PV}

src_compile() {
	emake en || die
}

src_install() {
	dobin mepl meplmail || die
	insinto /etc
	doins mepl.conf
	newman mepl.en mepl.7
}
