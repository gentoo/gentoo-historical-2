# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-java/jdictrayapi/jdictrayapi-0.8.7.ebuild,v 1.3 2005/03/16 18:04:47 luckyduck Exp $

inherit eutils java-pkg

DESCRIPTION="The JDesktop Integration Components (JDIC) tray icon API"
HOMEPAGE="https://jdic.dev.java.net/"

SRC_URI="https://jdic.dev.java.net/files/documents/880/9849/jdic-${PV}-src.zip"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="~x86 ~amd64"

MY_P="jdic"
S="${WORKDIR}/${MY_P}-${PV}-src/${MY_P}"

IUSE="doc examples jikes source"
DEPEND=">=virtual/jdk-1.4
		>=dev-java/ant-core-1.5.4
		app-arch/unzip
		jikes? ( >=dev-java/jikes-1.21 )
		source? ( app-arch/zip )"
RDEPEND=">=virtual/jre-1.4"

src_unpack() {
	unpack ${A}
	cd ${S}

	epatch ${FILESDIR}/${PV}-gentoo.patch

	for dir in $(find . -name CVS);
	do
		rm -rf ${dir}
	done
}

src_compile() {
	local antflags="buildtray"
	use doc && antflags="${antflags} docs"
	use jikes && antflags="${antflags} -Dbuild.compiler=jikes"
	ant ${antflags} || die "ant build failed"
}

src_install() {
	cd ${WORKDIR}/${MY_P}-${PV}-src/
	dodoc COPYING
	java-pkg_dohtml README.html

	cd ${S}/dist/linux
	java-pkg_dojar jdic.jar
	java-pkg_doso libtray.so

	if use doc; then
		java-pkg_dohtml -r docs/*
	fi
	if use source; then
		for dir in $(find ${S} -name CVS);
		do
			rm -rf ${dir}
		done

		java-pkg_dosrc ${S}/src/unix/*
	fi
	if use examples; then
		dodir /usr/share/doc/${PF}/examples
		cp -r ${S}/demo/* ${D}/usr/share/doc/${PF}/examples
	fi
}
