# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-java/hoteqn/hoteqn-4.0.0.ebuild,v 1.1 2007/12/10 22:37:44 caster Exp $

inherit java-pkg-2

DESCRIPTION="Java applet to view and display LaTeX mathematical equations"
HOMEPAGE="http://www.atp.ruhr-uni-bochum.de/VCLab/software/HotEqn/HotEqn.html"
SRC_URI="mirror://gentoo/${P}.tar.bz2"
LICENSE="GPL-3"
SLOT=0
KEYWORDS="~amd64"
IUSE=""
RDEPEND=">=virtual/jre-1.4"
DEPEND=">=virtual/jdk-1.4"

src_unpack() {
	unpack "${A}"
	rm -v "${S}"/mHotEqn.java || die
}

src_compile() {
	ejavac -nowarn -d classes $(find . -name "*.java") || die "failed to build"
	jar cf ${PN}.jar -C classes . || die "failed to create jar"
}

src_install() {
	java-pkg_dojar ${PN}.jar
}

pkg_postinst() {
	elog "We don't currently build the browser applet part. File a bug if you need it."
}
