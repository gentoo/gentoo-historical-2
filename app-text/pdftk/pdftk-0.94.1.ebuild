# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-text/pdftk/pdftk-0.94.1.ebuild,v 1.5 2005/01/01 16:30:05 eradicator Exp $

MY_P="${PN}-${PV%.*}${PV##*.}"	# 0.94.1 -> 0.941

DESCRIPTION="A tool for manipulating PDF documents"
HOMEPAGE="http://www.accesspdf.com/pdftk"
SRC_URI="http://www.accesspdf.com/pdftk/${MY_P}.tar.gz"
LICENSE="GPL-2"
SLOT="0"
KEYWORDS="x86"
IUSE=""
DEPEND="virtual/libc
	>=sys-devel/gcc-3.3"
S=${WORKDIR}/${MY_P}/${PN}

pkg_setup() {
	if [ -z "$(which gcj 2>/dev/null)" ]; then
		eerror "It seems that your system doesn't provides a Java compiler."
		eerror "Re-emerge sys-devel/gcc with \"java\" and \"gcj\" enabled."
		die "gcj not found."
	fi
}

src_unpack() {
	unpack ${A}
	# force usage of custom CFLAGS.
	mv ${S}/Makefile.Generic ${T}/Makefile.Generic.orig
	sed 's:-O2:\$(CFLAGS):g' \
		< ${T}/Makefile.Generic.orig > ${S}/Makefile.Generic
}

src_compile() {
	# java-config settings break compilation by gcj.
	unset CLASSPATH
	unset JAVA_HOME
	make -f Makefile.Generic || die "Compilation failed."
}

src_install() {
	dobin pdftk
	newman ../pdftk.1.manpage.txt pdftk.1
}
