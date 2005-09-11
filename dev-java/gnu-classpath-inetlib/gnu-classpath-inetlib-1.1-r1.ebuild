# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-java/gnu-classpath-inetlib/gnu-classpath-inetlib-1.1-r1.ebuild,v 1.1 2005/09/11 15:42:05 betelgeuse Exp $

inherit java-pkg

DESCRIPTION="Network extensions library for GNU classpath and classpathx"
HOMEPAGE="http://www.gnu.org/software/classpath/"
SRC_URI="ftp://ftp.gnu.org/gnu/classpath/inetlib-${PV}.tar.gz"
LICENSE="GPL-2"
SLOT="1.1"
KEYWORDS="~x86 ~ppc ~amd64"
IUSE="doc jikes"
RDEPEND=">=virtual/jre-1.3
	>=dev-java/jessie-0.9.7
	>=dev-java/gnu-crypto-2.0.1
	"
DEPEND=">=virtual/jdk-1.3
	${RDEPEND}
	jikes? ( >=dev-java/jikes-1.19 )"
S=${WORKDIR}/inetlib

src_unpack() {
	unpack ${A}
	cd ${S} ; mkdir ext
	cd ext
	java-pkg_jar-from jessie
	java-pkg_jar-from gnu-crypto
}


src_compile() {
	# TODO: Add back jikes support

	econf \
		--enable-smtp \
		--enable-imap \
		--enable-pop3 \
		--enable-nntp \
		--enable-ftp \
		--enable-gopher \
		--with-jsse-jar=${S}/ext \
		--with-javax-security-jar=${S}/ext \
		|| die
	make || die
	if use doc ; then
		make javadoc || die
	fi
}

src_install() {
	einstall || die
	rm -rf ${D}/usr/share/java
	java-pkg_dojar inetlib.jar
	use doc && java-pkg_dohtml -r docs/*
	dodoc AUTHORS NEWS README
}
