# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-java/rhino/rhino-1.5.5-r1.ebuild,v 1.1 2005/01/29 21:16:24 luckyduck Exp $

inherit eutils java-pkg

MY_P="rhino1_5R5"
DESCRIPTION="Rhino is an open-source implementation of JavaScript written entirely in Java. It is typically embedded into Java applications to provide scripting to end users"
SRC_URI="ftp://ftp.mozilla.org/pub/mozilla.org/js/${MY_P}.zip http://dev.gentoo.org/~karltk/projects/java/distfiles/rhino-swing-ex-1.0.zip"
HOMEPAGE="http://www.mozilla.org/rhino/"
LICENSE="NPL-1.1"
SLOT="1.5"
KEYWORDS="x86 ppc amd64 sparc ~ppc64"
IUSE="jikes doc"
S="${WORKDIR}/${MY_P}"
DEPEND="dev-java/ant-core
	>=virtual/jdk-1.3
	app-arch/unzip
	jikes? ( dev-java/jikes )"
RDEPEND=">=virtual/jre-1.3"

src_unpack() {
	unpack ${MY_P}.zip
	cd ${S}
	mkdir build/
	epatch ${FILESDIR}/00_dont-fetch-swing-ex.patch
	cp ${DISTDIR}/rhino-swing-ex-1.0.zip build/swingExSrc.zip || die "unpack error"

}

src_compile() {
	local antflags="jar"
	use jikes && antflags="${antflags} -Dbuild.compiler=jikes"
	ant ${antflags} || die "compilation error"
}

src_install() {
	dobin ${FILESDIR}/jsscript
	java-pkg_dojar build/*/js.jar
	use doc && java-pkg_dohtml -r docs/*
}
