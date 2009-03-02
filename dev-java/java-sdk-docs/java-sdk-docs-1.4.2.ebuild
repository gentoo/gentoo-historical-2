# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-java/java-sdk-docs/java-sdk-docs-1.4.2.ebuild,v 1.23 2009/03/02 18:50:18 armin76 Exp $

At="j2sdk-1_4_2-doc.zip"
S="${WORKDIR}/docs"
SRC_URI="j2sdk-1_4_2-doc.zip"
DESCRIPTION="Javadoc for Java SDK version 1.4.2"
HOMEPAGE="http://java.sun.com/j2se/1.4.2/download.html"
LICENSE="sun-j2sl"
SLOT="1.4.2"
KEYWORDS="amd64 ia64 ppc ppc64 x86"
IUSE=""
DEPEND=">=app-arch/unzip-5.50-r1"
RDEPEND=""
RESTRICT="fetch"

pkg_nofetch() {
	einfo "Please download ${SRC_URI} from ${HOMEPAGE} and move it to ${DISTDIR}"
}

src_unpack() {
	unpack ${At} || die "Failed Unpacking"
}

src_install(){
	dohtml index.html

	local dirs="api guide images relnotes tooldocs"

	for i in $dirs ; do
		cp -pPR $i "${D}"/usr/share/doc/${P}/html
	done
}
