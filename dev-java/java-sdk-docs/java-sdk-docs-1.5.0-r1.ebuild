# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-java/java-sdk-docs/java-sdk-docs-1.5.0-r1.ebuild,v 1.4 2006/10/14 15:51:03 nichoj Exp $

SRC_URI="jdk-1_5_0-doc-${PR}.zip"
DESCRIPTION="Javadoc for Java SDK version 1.5.0 Beta 2"
HOMEPAGE="http://java.sun.com/j2se/1.5.0/"
LICENSE="sun-j2sl"
SLOT="1.5.0"
KEYWORDS="-alpha amd64 -hppa -mips -ppc -sparc x86"
IUSE=""
DEPEND=">=app-arch/unzip-5.50-r1"
RESTRICT="fetch"

DOWNLOAD_URL="http://javashoplm.sun.com/ECom/docs/Welcome.jsp?StoreId=22&PartDetailId=jdk-1.5.0-doc-oth-JPR&SiteId=JSC&TransactionId=noreg"

S="${WORKDIR}/docs"

pkg_nofetch() {
	einfo "Please download jdk-1_5_0-doc.zip from "
	einfo "${DOWNLOAD_URL}"
	einfo "and place it in ${DISTDIR} named as"
	einfo "${SRC_URI}. Notice the ${PR}. Because Sun changes the doc zip file"
	einfo "without changing the filename, we have to resort to renaming to keep"
	einfo "the md5sum verification working existing and new downloads."
	einfo ""
	einfo "If emerge fails because of a md5sum error it is possible that Sun"
	einfo "has again changed the upstream release, try downloading the file"
	einfo "again or a newer revision if available. Otherwise report this to"
	einfo "http://bugs.gentoo.org/67266 and we will make a new revision."
}

src_install(){
	insinto /usr/share/doc/${P}/html
	doins index.html

	local dirs="api guide images relnotes tooldocs"
	for i in $dirs ; do
		doins -r $i
	done
}
