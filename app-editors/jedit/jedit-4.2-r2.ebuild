# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-editors/jedit/jedit-4.2-r2.ebuild,v 1.2 2006/07/22 21:55:20 nelchael Exp $

inherit java-pkg-2 eutils java-ant-2

MY_PV="${PV//./}"
MY_PV="${MY_PV//_/}"

DESCRIPTION="Programmer's editor written in Java"
HOMEPAGE="http://www.jedit.org"
SRC_URI="mirror://sourceforge/jedit/jedit${MY_PV}source.tar.gz"
LICENSE="GPL-2"
KEYWORDS="~amd64 ~ppc ~ppc64 ~sparc ~x86"
SLOT="0"
IUSE="doc"

RDEPEND=">=virtual/jre-1.4"
# FIXME doesn't like Java 1.6 for some reason
DEPEND="|| (
		=virtual/jdk-1.4*
		=virtual/jdk-1.5*
	)
	doc? (
		=app-text/docbook-xml-dtd-4.3*
		>=app-text/docbook-xsl-stylesheets-1.65.1
		dev-libs/libxslt
	)
	>=dev-java/ant-core-1.5.4"

S="${WORKDIR}/jEdit"

src_unpack() {
	unpack ${A}
	cd ${S}

	if use doc; then
		local xsl=$(echo /usr/share/sgml/docbook/xsl-stylesheets-*)
		xsl=${xsl// */}

		local xml=$(echo /usr/share/sgml/docbook/xml-dtd-4.3*)
		xml=${xml// */}

		echo "build.directory=." > build.properties
		echo "docbook.dtd.catalog=${xml}/docbook.cat" >> build.properties
		echo "docbook.xsl=${xsl}" >> build.properties
	fi
}
src_compile() {
	eant dist $(use_doc javadoc docs-html)
}

src_install() {
	dodir /usr/share/jedit
	dodir /usr/bin

	insinto /usr/share/jedit
	doins -r jedit.jar jars doc modes properties startup macros
	keepdir /usr/share/jedit/jars

	echo "#!/bin/bash" > ${PN}
	echo "java -jar /usr/share/jedit/jedit.jar \"\${@}\"" >> ${PN}
	dobin ${PN}

	insinto /usr/share/icons/hicolor/128x128/apps
	newins ${S}/doc/jedit.png jedit.pngs

	make_desktop_entry jedit "jEdit" jedit
}

pkg_postinst() {
	einfo "The system directory for jEdit plugins is"
	einfo "/usr/share/jedit/jars"
}

pkg_postrm() {
	einfo "jEdit plugins installed into /usr/share/jedit/jars"
	einfo "(after installation of jEdit itself) haven't been"
	einfo "removed. To get rid of jEdit completely, you may"
	einfo "want to run"
	einfo ""
	einfo "\trm -r /usr/share/jedit"
}
