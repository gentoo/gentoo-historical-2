# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-text/jabref/jabref-1.8.1.ebuild,v 1.1 2005/12/11 22:42:06 nichoj Exp $

inherit java-pkg eutils

DESCRIPTION="GUI frontend for BibTeX, written in Java"
HOMEPAGE="http://jabref.sourceforge.net/"
SRC_URI="mirror://sourceforge/jabref/JabRef-${PV/_beta/b}-src.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~x86 ~amd64 ~ppc"
IUSE="jikes doc"

RDEPEND=">=virtual/jre-1.4
	dev-java/spin
	>=dev-java/antlr-2.7.3
	=dev-java/jgoodies-forms-1*
	=dev-java/jgoodies-looks-1.2*"

DEPEND=">=virtual/jdk-1.4
	${RDEPEND}
	>=dev-java/ant-core-1.4.1
	jikes? ( dev-java/jikes )
	dev-java/junit"

src_unpack() {
	unpack ${A}

	cd ${S}
	# TODO submit upstream
	epatch ${FILESDIR}/${PN}-1.8-fix_jarbundler.patch
	# cleans up the way the classpath is setup in build.xml.
	# in particular, it makes it use *.jar instead of particular files
	epatch ${FILESDIR}/${PN}-1.8-classpath_cleanup.patch

	cd ${S}/lib && rm -f *.{zip,jar,class}
	java-pkg_jar-from antlr
	java-pkg_jar-from spin
	java-pkg_jar-from jgoodies-looks-1.2
	java-pkg_jar-from jgoodies-forms
}


src_compile() {
	local antflags="jars"
	use jikes && antflags="${antflags} -Dbuild.compiler=jikes"
	use doc && antflags="${antflags} -Dbuild.javadocs=build/docs/api javadocs"
	ant ${antflags} || die "Ant failed"
}

src_install() {
	java-pkg_dojar build/lib/${PN}.jar

	use doc && java-pkg_dohtml -r build/docs/api
	dodoc src/txt/README

	echo "#!/bin/bash" > ${PN}
	echo '$(java-config -J) -classpath $(java-config -p antlr,jgoodies-looks-1.2,jgoodies-forms,spin,jabref) net.sf.jabref.JabRef "$@"' >> ${PN}

	dobin ${PN}

	newicon src/images/JabRef-icon.png JabRef-icon.png
	make_desktop_entry jabref JabRef JabRef-icon.png Office
}
