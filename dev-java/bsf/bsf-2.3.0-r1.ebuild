# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-java/bsf/bsf-2.3.0-r1.ebuild,v 1.7 2005/01/01 18:12:12 eradicator Exp $

inherit java-pkg eutils

DESCRIPTION="Bean Script Framework"
HOMEPAGE="http://jakarta.apache.org/bsf/"
SRC_URI="http://cvs.apache.org/dist/jakarta/bsf/v2.3.0rc1/src/bsf-src-2.3.0.tar.gz mirror://gentoo/bsf-rhino-1.5.patch.bz2"
LICENSE="Apache-1.1"
SLOT="2.3"
KEYWORDS="x86"
IUSE="doc jython rhino"
# karltk: Is this really an RDEPEND, or just a CDEPEND?
RDEPEND="=www-servers/tomcat-5*"
DEPEND="${REPEND}
	jython? ( >=dev-java/jython-2.1-r5 )
	rhino? ( >=dev-java/rhino-1.4 )
	>=dev-java/ant-1.5.4"

src_unpack() {
	unpack ${A}

	epatch ${WORKDIR}/bsf-rhino-1.5.patch

	cd ${S}/src/build/lib
	java-pkg_jar-from rhino || die "Missing rhino"
	java-pkg_jar-from jython || die "Missing jython"
}

src_compile() {
	# This ebuild is sensitive to the system classpath, so we need to start with a 
	# pristine one.
	export CLASSPATH=

	# karltk: this is dirty. should be fixed when we overhaul tomcat
	# and the entire servlet/java server pages system
	local cp=/opt/tomcat5/common/lib/servlet-api.jar
	cp="${cp}:/opt/tomcat5/common/lib/jsp-api.jar"


	cp="${cp}:$(java-config -p rhino)"
	cp="${cp}:$(java-config -p jython)"

	local antflags=

	# karltk: fix this
#	use jikes && antflags="${antflags} -Dbuild.compiler=jikes"

	cd src
	export CLASSPATH=${cp}
	ant ${antflags} compile || die
	if use doc ; then
		ant ${antflags} javadocs || die
	fi
}

src_install() {
	java-pkg_dojar src/build/lib/bsf.jar

	use doc && java-pkg_dohtml -r src/build/javadocs/*
}
