# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-sound/jtagger/jtagger-2007.02.ebuild,v 1.1 2007/05/09 13:13:24 betelgeuse Exp $

JAVA_PKG_IUSE="source test"

inherit eutils java-pkg-2

DESCRIPTION="Powerful MP3 tag and filename editor"
HOMEPAGE="http://dronten.googlepages.com/jtagger"
SRC_URI="http://dronten.googlepages.com/${P}.jar"

LICENSE="GPL-2"
KEYWORDS="~x86"
IUSE=""
SLOT="0"

COMMON_DEP="
	dev-java/jlayer
	dev-java/jid3"
RDEPEND=">=virtual/jre-1.5
	>=dev-java/jgoodies-looks-2.0
	${COMMON_DEP}"

DEPEND="${COMMON_DEP}
	>=virtual/jdk-1.5
	app-arch/unzip
	test? ( dev-java/junit )"

src_unpack() {
	mkdir -p "${S}/src"
	cd "${S}/src"
	unpack ${A}
	rm -vr com/jgoodies || die
	rm -vr javazoom || die
	rm -vr org || die
	find . -name '*.class' -delete || die
	#Move the tests away
	mkdir -p ../test/com/googlepages/dronten/jtagger || die
	mv com/googlepages/dronten/jtagger/test \
		../test/com/googlepages/dronten/jtagger/test || die
}

src_compile() {
	local classpath=$(java-pkg_getjars jid3,jlayer)
	cd "${S}/src"
	find . -name '*.java'  -print > sources.list
	ejavac -encoding latin1 -cp ${classpath} @sources.list
	find . -name '*.class' -print > classes.list
	find . -name '*.png' -print >> classes.list
	touch myManifest
	jar cmf myManifest ${PN}.jar @classes.list || die "jar failed"
}

src_install() {
	java-pkg_dojar src/${PN}.jar
	java-pkg_register-dependency jgoodies-looks-2.0
	use source && java-pkg_dosrc src/com
	java-pkg_dolauncher jtagger --main com.googlepages.dronten.jtagger.JTagger
	newicon src/com/googlepages/dronten/jtagger/resource/jTagger.icon.png ${PN}.png
	make_desktop_entry jtagger "jTagger MP3 tag editor"
}

src_test() {
	cd "${S}/test"
	local cp=".:../src/${PN}.jar:$(java-pkg_getjars jid3,jlayer)"
	cp="${cp}:$(java-pkg_getjars --build-only junit)"
	find . -name '*.java'  -print > sources.list
	ejavac -cp ${cp} @sources.list
	ejunit -cp ${cp} \
		com.googlepages.dronten.jtagger.test.TestRenameAlbum \
		com.googlepages.dronten.jtagger.test.TestRenameFile \
		com.googlepages.dronten.jtagger.test.TestRenameTitle
}
