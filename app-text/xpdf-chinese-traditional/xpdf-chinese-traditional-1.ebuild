# Copyright 1999-2002 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-text/xpdf-chinese-traditional/xpdf-chinese-traditional-1.ebuild,v 1.2 2002/10/19 22:45:41 cselkirk Exp $

DESCRIPTION="Chinese (traditional) support for xpdf"
SRC_URI="ftp://ftp.foolabs.com/pub/xpdf/${PN}.tar.gz"
HOMEPAGE="http://www.foolabs.com/xpdf"
LICENSE="GPL-2"
KEYWORDS="x86 ppc"
SLOT="0"

DEPEND="app-text/xpdf"
RDEPEND="${DEPEND}"

S=${WORKDIR}/${PN}

src_compile() {
	cat /etc/xpdfrc > ${S}/xpdfrc
	sed 's,/usr/local/share/xpdf/,/usr/share/xpdf/,g' ${S}/add-to-xpdfrc >> ${S}/xpdfrc
}

src_install() {
	into /usr
	dodoc README
	insinto /etc
	doins xpdfrc
	insinto /usr/share/xpdf/chinese-traditional
	doins *.unicodeMap *.cid*
	insinto /usr/share/xpdf/chinese-traditional/CMap
	doins CMap/*
}
