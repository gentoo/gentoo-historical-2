# Copyright 1999-2003 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-text/expander/expander-2.0.5.ebuild,v 1.1 2003/10/30 04:07:34 brandy Exp $

DESCRIPTION="Expander is a utility that acts as a filter for text editors."
HOMEPAGE="http://www.nedit.org"
SRC_URI="ftp://ftp.nedit.org/pub/contrib/misc/nedit_expander_kit_2.05.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~x86"

IUSE=""

DEPEND=""

S=${WORKDIR}/${PN}

src_unpack() {

	unpack ${A}
	cd ${S}
	epatch ${FILESDIR}/${P}-gentoo.patch

}

src_compile() {

	cd ${S}/src
	make || die "make failed"

}

src_install() {

	cd ${S}/src
	dobin expander boxcomment align_columns align_comments where_is
	dosym /usr/bin/boxcomment /usr/bin/unboxcomment

	insinto /usr/share/${P}
	doins ${S}/service
	for x in defs macros misc templates ; do
		insinto /usr/share/${P}/${x}
		doins ${S}/${x}/*
	done

	cd ${S}/docs
	doman *.1

	cd ${S}
	dodoc ChangeLog INSTALL README USAGE

}

pkg_postinst() {

	einfo
	einfo "Instructions for using expander with NEdit are in /usr/share/doc/${P}/INSTALL"
	einfo "Macro, definition and template files can be found in /usr/share/${P}"
	einfo

}
