# Copyright 1999-2004 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/mail-filter/scmail/scmail-0.2.ebuild,v 1.1 2004/06/03 07:30:00 seemant Exp $

inherit eutils

IUSE=""

HOMEPAGE="http://namazu.org/~satoru/scmail/"
DESCRIPTION="a mail filter written in Scheme"
SRC_URI="http://namazu.org/~satoru/scmail/${P}.tar.gz"

LICENSE="GPL-2"
KEYWORDS="x86"
SLOT="0"

DEPEND=">=dev-lisp/gauche-0.6.3"

src_unpack() {

	unpack ${A}
	epatch ${FILESDIR}/${P}-gentoo.diff

}

src_compile() {

	emake || die

}

src_install() {

	einstall PREFIX=${D}/usr || die

	dodoc scmailrc*.sample doc/*

}
