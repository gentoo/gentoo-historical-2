# Copyright 1999-2003 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-java/java-sdk-docs/java-sdk-docs-1.3.1.ebuild,v 1.7 2003/08/08 22:57:46 strider Exp $

At="j2sdk-1_3_1-doc.zip"
S="${WORKDIR}/docs"
SRC_URI=""
DESCRIPTION="Javadoc for Java SDK version 1.3.1"
HOMEPAGE="http://java.sun.com/j2se/1.3/docs.html"
LICENSE="sun-j2sl"
SLOT="1.3"
KEYWORDS="x86 ppc sparc alpha"
DEPEND="app-arch/unzip"
RESTRICT="fetch"

src_unpack() {
	if [ ! -f ${DISTDIR}/${At} ] ; then
		die "Please download ${At} from ${HOMEPAGE} and move it to ${DISTDIR}"
	fi
	unpack ${At} || die
}

src_install(){
	dohtml index.html

	local dirs="api guide images relnotes tooldocs"
	
	for i in $dirs ; do
		cp -a $i ${D}/usr/share/doc/${P}/html
	done	
}
