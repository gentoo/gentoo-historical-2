# Copyright 1999-2004 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-java/fop-bin/fop-bin-0.20.5.ebuild,v 1.4 2004/02/25 18:19:21 absinthe Exp $

MY_P=${P/-bin/}
DESCRIPTION="Formatting Objects Processor is a print formatter driven by XSL"
SRC_URI="mirror://apache/xml/fop/${MY_P}-bin.tar.gz"
HOMEPAGE="http://xml.apache.org/fop/"

LICENSE="Apache-1.1"
SLOT="0"
KEYWORDS="x86 amd64"

DEPEND=">=virtual/jdk-1.4
		!dev-java/fop"

S=${WORKDIR}/${MY_P}

src_install() {
	sed '2itest "$FOP_HOME" || FOP_HOME=/usr/share/fop/' fop.sh > fop
	exeinto /usr/bin
	doexe fop

	env PN=${PN/-bin/} dojar lib/*.jar build/*.jar
	dodoc LICENSE README CHANGES ReleaseNotes.html STATUS
	dodoc lib/*.txt docs/*.pdf conf/*
	dohtml -r docs/html-docs/*
}
