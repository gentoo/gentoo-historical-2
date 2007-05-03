# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-java/ant-core/ant-core-1.7.0.ebuild,v 1.10 2007/05/03 18:17:41 armin76 Exp $

# don't depend on itself
JAVA_ANT_DISABLE_ANT_CORE_DEP=true
# rewriting build.xml files for the testcases has no reason atm
JAVA_PKG_BSFIX_ALL=no
inherit java-pkg-2 java-ant-2

MY_P="apache-ant-${PV}"

DESCRIPTION="Java-based build tool similar to 'make' that uses XML configuration files."
HOMEPAGE="http://ant.apache.org/"
SRC_URI="mirror://apache/ant/source/${MY_P}-src.tar.bz2
	mirror://gentoo/ant-${PV}-gentoo.tar.bz2"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64 ia64 ~ppc ~ppc64 ~x86 ~x86-fbsd"
IUSE="doc source"

# 1.7.0 instead of $PV in blocks is intentional, >1.7.0 upgrades should
# be block free (but these fixed blocks should stay there for users upgrading
# from <1.7.0 of course)
RDEPEND=">=virtual/jdk-1.4
	!<dev-java/ant-tasks-1.7.0
	!<dev-java/ant-1.7.0
	!dev-java/ant-optional"
DEPEND="${RDEPEND}
	source? ( app-arch/zip )"

S="${WORKDIR}/${MY_P}"

src_unpack() {
	unpack ${A}
	cd "${S}"

	# remove bundled xerces
	rm -v lib/*.jar

	# use our split-ant build.xml
	mv -f ${WORKDIR}/build.xml .
}

src_compile() {
	export ANT_HOME=""

	local bsyscp

	# this ensures that when building ant with bootstrapped ant,
	# only the source is used for resolving references, and not
	# the classes in bootstrapped ant
	# but jikes in kaffe has issues with this...
	if ! java-pkg_current-vm-matches kaffe; then
		bsyscp="-Dbuild.sysclasspath=ignore"
	fi

	./build.sh ${bsyscp} jars-core $(use_doc javadocs) \
		|| die "build failed"
}

src_install() {
	newbin ${FILESDIR}/${PV}-ant ant || die "failed to install wrapper"

	dodir /usr/share/${PN}/bin
	for each in antRun runant.pl runant.py complete-ant-cmd.pl ; do
		dobin ${S}/src/script/${each}
		dosym /usr/bin/${each} /usr/share/${PN}/bin/${each}
	done

	echo "ANT_HOME=\"/usr/share/${PN}\"" > ${T}/20ant
	doenvd ${T}/20ant || die "failed to install env.d file"

	java-pkg_dojar build/lib/ant.jar
	java-pkg_dojar build/lib/ant-bootstrap.jar
	java-pkg_dojar build/lib/ant-launcher.jar

	use source && java-pkg_dosrc src/main/*

	dodoc README WHATSNEW KEYS

	if use doc; then
		dohtml welcome.html
		dohtml -r docs/*
		java-pkg_dojavadoc build/javadocs
	fi
}

pkg_postinst() {
	elog "The way of packaging ant in Gentoo has changed significantly since"
	elog "the 1.7.0 version, For more information, please see:"
	elog "http://www.gentoo.org/proj/en/java/ant-guide.xml"
}
