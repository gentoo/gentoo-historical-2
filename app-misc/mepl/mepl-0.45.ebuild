# Copyright 1999-2004 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-misc/mepl/mepl-0.45.ebuild,v 1.5 2004/06/24 22:24:13 agriffis Exp $

SRC_URI="http://www.hof-berlin.de/mepl/mepl${PV}.tar.gz"
HOMEPAGE="http://www.hof-berlin.de/mepl/"
DESCRIPTION="Self-employed-mode software for 3COM/USR message modems"
LICENSE="GPL-2"
KEYWORDS="x86"
SLOT="0"
IUSE=""

DEPEND="virtual/glibc"

S=${WORKDIR}/${PN}${PV}

src_compile () {
	emake en
}

src_install () {
	dobin mepl meplmail
	insinto /etc
	doins mepl.conf
	cp mepl.en mepl.7
	doman mepl.7
}
