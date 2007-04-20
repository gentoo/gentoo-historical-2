# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-java/ant-owanttask/ant-owanttask-1.1-r12.ebuild,v 1.3 2007/04/20 10:41:42 betelgeuse Exp $

inherit eutils java-pkg-2 java-ant-2

DESCRIPTION="ObjectWeb's Ant tasks"
HOMEPAGE="http://monolog.objectweb.org"
MY_P="owanttask-${PV}"
SRC_URI="http://www.gentoo.org/~karltk/java/distfiles/${MY_P}-gentoo.tar.bz2"
LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="~x86 ~ppc ~amd64"
IUSE=""
COMMON_DEP="dev-java/xalan"
DEPEND=">=virtual/jdk-1.4
	${COMMON_DEP}"
RDEPEND=">=virtual/jre-1.4
	>=dev-java/ant-core-1.7.0
	${COMMON_DEP}"

S=${WORKDIR}/${MY_P}

src_unpack() {
	unpack ${A}
	cd "${S}"
	epatch "${FILESDIR}/${P}-classpath.patch"

	cp -f "${FILESDIR}/MultipleCopy.java" src/org/objectweb/util/ant

	mkdir lib
	cd lib
	java-pkg_jar-from ant-core ant.jar
	java-pkg_jar-from xalan
}

src_install() {
	java-pkg_dojar output/lib/ow_util_ant_tasks.jar
}

pkg_postinst() {
	ewarn "The MultipleCopy task is not compatible with ant-1.7.0 and newer"
	ewarn "Attempt to use it will break building."
}
