# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-arch/unadf/unadf-0.7.9b.ebuild,v 1.4 2005/11/29 03:00:46 vapier Exp $

inherit eutils

DESCRIPTION="Extract files from Amiga adf disk images"
SRC_URI="http://perso.club-internet.fr/lclevy/adflib/adflib.zip"
HOMEPAGE="http://perso.club-internet.fr/lclevy/adflib/adflib.html"
LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~hppa ~ppc ~ppc-macos ~x86"
IUSE=""
DEPEND="app-arch/unzip"
RDEPEND=""

src_unpack() {
	mkdir ${S}
	cd ${S}
	unzip ${DISTDIR}/adflib.zip
	epatch ${FILESDIR}/no.in_path.patch
}

src_compile() {
	cd ${S}/Lib && make depend || die "make failed"
	cd ${S}/Demo && make depend || die "make failed"
	cd ${S} && emake lib demo || die "emake failed"
}

src_install() {
	dobin Demo/unadf
	dodoc README CHANGES Faq/adf_info.txt
	docinto Docs
	dodoc Docs/*
	docinto Faq
	dodoc Faq/*
	docinto Faq/image
	dodoc Faq/image/*
}
