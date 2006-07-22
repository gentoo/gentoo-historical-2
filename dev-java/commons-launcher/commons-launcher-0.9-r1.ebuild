# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-java/commons-launcher/commons-launcher-0.9-r1.ebuild,v 1.1 2006/07/22 22:59:45 nelchael Exp $

inherit java-pkg-2 java-ant-2

DESCRIPTION="Commons-launcher eliminates the need for a batch or shell script to launch a Java class."
HOMEPAGE="http://jakarta.apache.org/commons/launcher/"
SRC_URI="ftp://ftp.ibiblio.org/pub/mirrors/apache/jakarta/commons/launcher/source/launcher-0.9-src.tar.gz"
LICENSE="Apache-1.1"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~ppc64 ~sparc ~x86"
IUSE="doc source"
DEPEND=">=virtual/jdk-1.4
	>=dev-java/ant-core-1.4
	source? ( app-arch/zip )"
RDEPEND=">=virtual/jre-1.4"
S=${WORKDIR}/${PN}

src_compile() {
	local antflags="jar"
	use doc && antflags="${antflags} javadoc"
	eant ${antflags} || die "compilation problem"
}

src_install() {
	java-pkg_dojar dist/bin/*.jar || die "java-pkg_dojar died"
	dohtml *.html
	use doc && java-pkg_dohtml -r dist/docs/*
	use source && java-pkg_dosrc src/java/*
}
