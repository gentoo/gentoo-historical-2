# Copyright 1999-2002 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-text/xpdf-japanese/xpdf-japanese-1.ebuild,v 1.2 2002/09/02 03:09:07 jmorgan Exp $

DESCRIPTION="Japanese support for xpdf"
SRC_URI="ftp://ftp.foolabs.com/pub/xpdf/${PN}.tar.gz"
HOMEPAGE="http://www.foolabs.com/xpdf"
LICENSE="GPL-2"
KEYWORDS="x86 sparc sparc64"
SLOT="0"

DEPEND="app-text/xpdf"
RDEPEND="${DEPEND}"

S=${WORKDIR}/${PN}

src_compile() {
	cat /etc/xpdfrc > ${S}/xpdfrc
	sed 's,/usr/local/share/xpdf/,/usr/share/xpdf/,g' ${S}/add-to-xpdfrc >> ${S}/xpdfrc
}

src_install() {
	# don't use builtin make install, as it doesn't compress manpages
	into /usr
	dodoc README
	insinto /etc
	doins xpdfrc
	insinto /usr/share/xpdf/japanese
	doins *.unicodeMap *.cid*
	insinto /usr/share/xpdf/japanese/CMap
	doins CMap/*
}
