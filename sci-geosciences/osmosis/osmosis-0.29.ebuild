# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sci-geosciences/osmosis/osmosis-0.29.ebuild,v 1.2 2008/11/16 12:41:58 hanno Exp $

WANT_ANT_TASKS="ant-nodeps"
inherit java-pkg-2 java-ant-2

DESCRIPTION="Commandline tool to process openstreetmap data"
HOMEPAGE="http://wiki.openstreetmap.org/index.php/Osmosis"
SRC_URI="http://gweb.bretth.com/${P}.tar.gz"
LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""
DEPEND=">=virtual/jdk-1.5"
RDEPEND=">=virtual/jre-1.5"
S="${WORKDIR}/${P}"

src_compile() {
	eant build_binary || die
}

src_install() {
	java-pkg_newjar "${PN}.jar" || die "java-pkg_newjar failed"
	java-pkg_dolauncher "${PN}" --jar "${PN}.jar" || die "java-pkg_dolauncher failed"

	dodoc readme.txt changes.txt doc/*.txt || die "dodoc failed"
}
