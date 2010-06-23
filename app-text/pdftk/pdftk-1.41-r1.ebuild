# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-text/pdftk/pdftk-1.41-r1.ebuild,v 1.6 2010/06/23 08:24:20 chithanh Exp $

EAPI="2"

inherit eutils

DESCRIPTION="A tool for manipulating PDF documents"
HOMEPAGE="http://www.pdfhacks.com/pdftk"
SRC_URI="http://www.pdfhacks.com/pdftk/${P}.tar.gz"
LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ppc ~ppc64 x86"
IUSE="nodrm"
DEPEND=">=sys-devel/gcc-4.3.1[gcj]"

S="${WORKDIR}/${P}/${PN}"

src_unpack() {
	unpack ${A}

	#bug #225709 and #251796
	epatch "${FILESDIR}/${P}-gcc-4.3.patch"
	#bug #269312
	epatch "${FILESDIR}/${P}-gcc-4.4.patch"
	#bug #209802
	epatch "${FILESDIR}/${P}-honor-ldflags.patch"
	# force usage of custom CFLAGS.
	sed -iorig 's:-O2:\$(CFLAGS):g' "${S}"/Makefile.Generic
	# nodrm patch, bug 296455
	if use nodrm; then
		sed -i 's:passwordIsOwner= false:passwordIsOwner= true:' "${WORKDIR}/${P}"/java_libs/com/lowagie/text/pdf/PdfReader.java || die
	fi
}

src_compile() {
	# java-config settings break compilation by gcj.
	unset CLASSPATH
	unset JAVA_HOME
	# parallel make fails
	emake -j1 -f Makefile.Generic || die "Compilation failed."
}

src_install() {
	dobin pdftk
	newman ../debian/pdftk.1 pdftk.1
	dohtml ../pdftk.1.html
}
