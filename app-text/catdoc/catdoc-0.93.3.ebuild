# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-text/catdoc/catdoc-0.93.3.ebuild,v 1.10 2007/04/20 22:11:32 beandog Exp $

DESCRIPTION="A convertor for Microsoft Word, Excel and RTF Files to text"
HOMEPAGE="http://www.45.free.net/~vitus/software/catdoc/"
SRC_URI="ftp://ftp.45.free.net/pub/${PN}/${P}.tar.gz"
LICENSE="GPL-2"

IUSE="tk"
SLOT="0"
KEYWORDS="amd64 ~ppc x86"

DEPEND="tk? ( >=dev-lang/tk-8.1 )"

DOCS="CODING.STD CREDITS NEWS README TODO"

src_compile() {

	local myconf="--with-install-root=${D}"

	use tk \
		&& myconf="${myconf} --with-wish=/usr/bin/wish" \
		|| myconf="${myconf} --disable-wordview"

	econf ${myconf} || die
	emake LIB_DIR=/usr/share/catdoc || die

}

src_install() {

	make mandir=/usr/share/man/man1 install || die
	dodoc ${DOCS}

}


