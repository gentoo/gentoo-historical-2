# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-java/gnu-crypto/gnu-crypto-2.0.1-r2.ebuild,v 1.8 2007/03/09 21:38:37 nixnut Exp $

inherit java-pkg-2 eutils

DESCRIPTION="GNU Crypto cryptographic primitives for Java"
HOMEPAGE="http://www.gnu.org/software/gnu-crypto/"
SRC_URI="ftp://ftp.gnupg.org/GnuPG/gnu-crypto/gnu-crypto-2.0.1.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~ia64 ppc ppc64 x86 ~x86-fbsd"
IUSE="doc source"

DEPEND=">=virtual/jdk-1.3"
RDEPEND=">=virtual/jre-1.3"

RESTRICT="test"

src_unpack() {
	unpack ${A}
	cd "${S}"

	epatch "${FILESDIR}/${P}-jdk15.patch"
}

src_compile() {
	# jikes support disabled, doesnt work: #86655
	econf JAVAC="javac" JAVACFLAGS="$(java-pkg_javac-args)" --with-jce=yes --with-sasl=yes || die
	emake -j1 || die
	if use doc ; then
		emake -j1 javadoc || die
	fi
}

src_install() {
	einstall || die
	rm ${D}/usr/share/*.jar

	java-pkg_dojar source/gnu-crypto.jar
	java-pkg_dojar jce/javax-crypto.jar
	java-pkg_dojar security/javax-security.jar

	use doc && java-pkg_dojavadoc api
	use source && java-pkg_dosrc source/* jce/* security/*

	dodoc AUTHORS ChangeLog NEWS README THANKS || die
}
