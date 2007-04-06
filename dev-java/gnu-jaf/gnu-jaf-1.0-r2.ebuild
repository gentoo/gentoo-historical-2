# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-java/gnu-jaf/gnu-jaf-1.0-r2.ebuild,v 1.10 2007/04/06 23:00:03 betelgeuse Exp $

inherit java-pkg-2

DESCRIPTION="GNU implementation of the JavaBeans Activation Framework"
HOMEPAGE="http://www.gnu.org/software/classpathx/jaf/jaf.html"
SRC_URI="mirror://gnu/classpathx/activation-${PV}.tar.gz"

LICENSE="GPL-2-with-linking-exception"
SLOT="1"
KEYWORDS="amd64 ppc ppc64 x86 ~x86-fbsd"
IUSE="doc source"

# doesn't like 1.6+ because of bundled javax.activation which it can't override
# with own (endorsed standards?), and which doesn't have a particular exception
# constructor gnu-jaf expects
DEPEND="|| ( =virtual/jdk-1.4* =virtual/jdk-1.5* )
	source? ( app-arch/zip )"
RDEPEND=">=virtual/jre-1.4"

S=${WORKDIR}/activation-${PV}

src_compile() {
	econf || die "configure failed"
	# funky Makefile
	make JAVACFLAGS="${JAVACFLAGS}" || die "make failed"

	if use doc; then
		make javadoc || die "failed to create javadoc"
	fi
}

src_install() {
	java-pkg_dojar activation.jar
	dodoc AUTHORS ChangeLog || die
	use doc && java-pkg_dojavadoc docs
	use source && java-pkg_dosrc source/*
}
