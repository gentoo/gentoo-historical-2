# Copyright 1999-2003 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-java/oro/oro-2.0.6-r2.ebuild,v 1.4 2003/08/05 18:53:42 vapier Exp $

DESCRIPTION="A set of text-processing Java classes that provide Perl5 compatible regular expressions, AWK-like regular expressions, glob expressions, and utility classes for performing substitutions, splits, filtering filenames, etc."
HOMEPAGE="http://jakarta.apache.org/oro/index.html"
SRC_URI="mirror://apache/jakarta/oro/source/jakarta-oro-${PV}.tar.gz"

LICENSE="Apache-1.1"
SLOT="0"
KEYWORDS="x86 ppc sparc"
IUSE="doc jikes"

DEPEND=">=virtual/jdk-1.3
	>=dev-java/ant-1.4
	jikes? ( >=dev-java/jikes-1.17 )"
RDEPEND=">=virtual/jdk-1.3"

S=${WORKDIR}/jakarta-oro-${PV}

src_compile() {
	local myc

	if [ -n "`use jikes`" ] ; then
		myc="${myc} -Dbuild.compiler=jikes"
	fi

	ANT_OPTS=${myc} ant jar || die "Failed Compiling"

	if [ -n "`use doc`" ] ; then
		ant javadocs || die "Failed Creating Docs"
	fi
}

src_install() {
	mv jakarta-oro*.jar oro.jar
	dojar oro.jar || die "Failed Installing"
	dodoc BUGS CHANGES COMPILE CONTRIBUTORS README STYLE TODO
	dohtml *.html

	[ -n "`use doc`" ] && dohtml -r docs/
}
