# Copyright 1999-2004 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-java/bsf/bsf-2.3.0-r2.ebuild,v 1.6 2004/11/16 00:08:14 karltk Exp $

inherit java-pkg eutils

DESCRIPTION="Bean Script Framework"
HOMEPAGE="http://jakarta.apache.org/bsf/"
SRC_URI="http://cvs.apache.org/dist/jakarta/bsf/v2.3.0rc1/src/bsf-src-2.3.0.tar.gz mirror://gentoo/bsf-rhino-1.5.patch.bz2"
LICENSE="Apache-1.1"
SLOT="2.3"
KEYWORDS="~x86 ~ppc ~sparc"
IUSE="doc jython rhino jikes"
RDEPEND=">=virtual/jre-1.4
	jython? ( >=dev-java/jython-2.1-r5 )
	rhino? ( >=dev-java/rhino-1.4 )
	=dev-java/servletapi-2.3*
	>=dev-java/ant-1.5.4"
DEPEND=">=virtual/jdk-1.4
	jikes? ( >=dev-java/jikes-1.18 )
	${RDEPEND}"


src_unpack() {
	unpack ${A}

	epatch ${WORKDIR}/bsf-rhino-1.5.patch

	cd ${S}/src/build/lib
	if use rhino; then
		java-pkg_jar-from rhino || die "Missing rhino"
	fi

	if use jython; then
		java-pkg_jar-from jython || die "Missing jython"
	fi

}

src_compile() {

	use rhino && cp="${cp}:$(java-config -p rhino)"
	use jython && cp="${cp}:$(java-config -p jython)"

	# karltk: fix this
	use jikes && antflags="${antflags} -Dbuild.compiler=jikes"

	cd ${S}/src/taglib
	ant ${antflags} -Dservlet.jar="$(java-config -p servletapi-2.3)" compile || die "Failed to build taglib"

	cd ${S}/src
	ant ${antflags} -Dclasspath=${cp} compile || die "Failed to build main package"
	if use doc ; then
		ant ${antflags} javadocs || die
	fi
}

src_install() {
	java-pkg_dojar src/build/lib/bsf.jar

	use doc && java-pkg_dohtml -r src/build/javadocs/*
}
