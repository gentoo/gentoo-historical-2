# Copyright 1999-2004 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-java/classworlds/classworlds-1.0-r2.ebuild,v 1.2 2004/05/07 13:39:32 dholm Exp $

inherit java-pkg

DESCRIPTION="Advanced classloader framework"
HOMEPAGE="http://dist.codehaus.org/classworlds/distributions/classworlds-1.0-src.tar.gz"
SRC_URI="http://dist.codehaus.org/classworlds/distributions/${P}-src.tar.gz"
LICENSE="codehaus-classworlds"
SLOT="1"
KEYWORDS="~x86 ~ppc"
IUSE="doc jikes"
DEPEND="=dev-java/xerces-2.6*"
S=${WORKDIR}/${P}

src_unpack() {
	unpack ${A}
	cp ${FILESDIR}/build-${PV}.xml ${S}/build.xml
	mkdir -p ${S}/target/lib

	cd ${S}/target/lib

	# karltk: remove the fake versioning here.
	java-pkg_jar-from xerces || die "Missing xerces"
}

src_compile() {
	local myconf
	use jikes && myconf="${myconf} -Dbuild.compiler=jikes"

	ant ${myconf} jar || die "Failed to compile jars"
	if (use doc) ; then
		ant javadoc || die "Failed to generate docs"
	fi
}

src_install() {
	dodoc LICENSE.txt
	java-pkg_dojar target/classworlds-1.0.jar
	use doc && dohtml -r dist/docs/api
}
