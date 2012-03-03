# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-java/cortado/cortado-0.6.0.ebuild,v 1.1 2012/03/03 20:17:54 tupone Exp $

EAPI=2

inherit java-pkg-2 java-ant-2

DESCRIPTION="Multimedia framework for Java written by Fluendo"
HOMEPAGE="http://www.theora.org/cortado/"
SRC_URI="http://downloads.xiph.org/releases/cortado/${P}.tar.gz"

LICENSE="GPL-2 LGPL-2"
SLOT="0"
KEYWORDS="~x86"

IUSE=""

COMMON_DEP=""

RDEPEND=">=virtual/jre-1.4
	${COMMON_DEP}"
DEPEND=">=virtual/jdk-1.4
	app-arch/unzip
	${COMMON_DEP}"

EANT_BUILD_TARGET=stripped

src_install() {
	java-pkg_newjar output/dist/applet/${PN}-ovt-stripped-${PV}.jar
	dodoc ChangeLog HACKING NEWS README RELEASE TODO \
		|| die "dodoc failed"
}
