# Copyright 1999-2004 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-java/jmf/jmf-2.1.1e.ebuild,v 1.9 2004/06/24 22:35:21 agriffis Exp $

inherit java-pkg

At="${PN}-2_1_1e-alljava.zip"
S=${WORKDIR}/JMF-2.1.1e
DESCRIPTION="The Java Media Framework API (JMF) enables audio, video and other time-based media to be added to Java applications and applets."
SRC_URI="${At}"
HOMEPAGE="http://java.sun.com/products/java-media/jmf/"
KEYWORDS="x86 sparc amd64 ~ppc"
LICENSE="sun-bcla-jmf"
SLOT="0"
DEPEND=">=app-arch/unzip-5.50-r1"
RDEPEND=">=virtual/jdk-1.4"
RESTRICT="fetch"

pkg_nofetch() {
	einfo " "
	einfo " Due to license restrictions, we cannot fetch the"
	einfo " distributables automagically."
	einfo " "
	einfo " 1. Visit ${HOMEPAGE} and select 'Cross Platform Java'"
	einfo " 2. Download ${At}"
	einfo " 3. Move file to ${DISTDIR}"
	einfo " 4. Run emerge on this package again to complete"
	einfo " "
}

src_unpack() {
	if [ ! -f "${DISTDIR}/${At}" ] ; then
		echo  " "
		echo  "!!! Missing ${DISTDIR}/${At}"
		echo  " "
		einfo " "
		einfo " Due to license restrictions, we cannot fetch the"
		einfo " distributables automagically."
		einfo " "
		einfo " 1. Visit ${HOMEPAGE} and select 'Cross Platform Java'"
		einfo " 2. Download ${At}"
		einfo " 3. Move file to ${DISTDIR}"
		einfo " 4. Run emerge on this package again to complete"
		einfo " "
		die "User must manually download distfile"
	fi
	unzip -qq ${DISTDIR}/${At}
}

src_compile() {
	einfo " This is a binary-only ebuild."
}

src_install() {
	dobin \
		${FILESDIR}/jmfcustomizer \
		${FILESDIR}/jmfinit \
		${FILESDIR}/jmfregistry \
		${FILESDIR}/jmstudio
	dohtml ${S}/doc/*.html
	java-pkg_dojar ${S}/lib/*.jar
	insinto /usr/share/${PN}/lib
	doins lib/jmf.properties
}

