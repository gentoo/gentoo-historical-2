# Copyright 1999-2004 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-text/itext/itext-1.02b.ebuild,v 1.3 2004/06/24 22:41:27 agriffis Exp $

inherit java-pkg

DESCRIPTION="A Java library that generate documents in the Portable Document Format (PDF) and/or HTML."
HOMEPAGE="http://www.lowagie.com/iText/"
SRC_URI="http://www.lowagie.com/iText/build.xml"
IUSE="doc jikes"

LICENSE="MPL-1.1"
SLOT="0"
KEYWORDS="~x86"

DEPEND=">=virtual/jdk-1.2
		>=dev-java/ant-1.4
		dev-java/sun-j2ee
		jikes? ( dev-java/jikes )"
RDEPEND=">=virtual/jre-1.2"

S=${WORKDIR}

src_unpack() {
	cp ${DISTDIR}/build.xml ${WORKDIR}
}

src_compile() {
	[ -z $J2EE_HOME ] && export J2EE_HOME="/opt/sun-j2ee-1.3.1"
	einfo ${J2EE_HOME}
	ant download.site
	local antflags="jarWithXML"
	use jikes && antflags="${antflags} -Dbuild.compiler=jikes"
	use doc && antflags="${antflags} javadoc"
	ant ${antflags}
}

src_install() {
	java-pkg_dojar dist/*
	use doc && dohtml -r docs/*
}
