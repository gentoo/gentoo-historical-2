# Copyright 1999-2004 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-java/mckoi/mckoi-1.0.2.ebuild,v 1.5 2004/11/03 11:34:59 axxo Exp $

inherit java-pkg

DESCRIPTION="Mckoi Java SQL Database System"
HOMEPAGE="http://mckoi.com/database/"
SRC_URI="http://www.mckoi.com/database/ver/${PN}${PV}.zip"
LICENSE="GPL-2"
SLOT="1"
KEYWORDS="x86"
IUSE="doc"
DEPEND="=dev-java/gnu-regexp-1.1*
		app-arch/unzip"
#RDEPEND=""
S=${WORKDIR}/${PN}${PV}

src_unpack() {
	unpack ${A}
	cd ${S}
	rm gnu-regexp-*
	rm mckoidb.jar
	rm mkjdbc.jar
	unzip -q src.zip || die
	mkdir lib
}

src_compile() {
	javac -classpath src:lib:`java-config -p gnu-regexp` -d lib/ \
		src/com/mckoi/runtime/McKoiDBMain.java \
		src/com/mckoi/JDBCDriver.java \
		src/com/mckoi/database/jdbcserver/DefaultLocalBootable.java \
		src/com/mckoi/database/interpret/*.java \
		src/com/mckoi/database/control/*.java \
		src/com/mckoi/tools/*.java \
		src/com/mckoi/database/regexbridge/GNURegex.java || die
	(
		cd lib
		jar cf mckoidb-${PV}.jar com
	)
	if (use doc) ; then
		javadoc \
			src/com/mckoi/runtime/McKoiDBMain.java \
			src/com/mckoi/JDBCDriver.java \
			src/com/mckoi/database/jdbcserver/DefaultLocalBootable.java \
			src/com/mckoi/database/interpret/*.java \
			src/com/mckoi/database/control/*.java \
			src/com/mckoi/tools/*.java \
			src/com/mckoi/database/regexbridge/GNURegex.java || die
	fi
}

src_install() {
	dodoc LICENSE.txt README.txt db.conf
	java-pkg_dojar lib/mckoidb-${PV}.jar
	use doc && java-pkg_dohtml -r docs
}
