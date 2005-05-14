# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-text/catdoc/catdoc-0.93.4.ebuild,v 1.2 2005/05/14 00:57:32 wormo Exp $

DESCRIPTION="A convertor for Microsoft Word, Excel and RTF Files to text"
HOMEPAGE="http://www.45.free.net/~vitus/ice/catdoc/"
SRC_URI="ftp://ftp.45.free.net/pub/${PN}/${P}.tar.gz"
LICENSE="GPL-2"

IUSE="tcltk"
SLOT="0"
KEYWORDS="~x86 ~amd64 ~ppc"

DEPEND="tcltk? ( >=dev-lang/tk-8.1 )"

DOCS="CODING.STD COPYING CREDITS INSTALL NEWS README TODO"

src_compile() {

	local myconf="--with-install-root=${D}"

	use tcltk \
		&& myconf="${myconf} --with-wish=/usr/bin/wish" \
		|| myconf="${myconf} --disable-wordview"

	econf ${myconf} || die
	emake LIB_DIR=/usr/share/catdoc || die

}

src_install() {

	make mandir=/usr/share/man/man1 install || die
	dodoc ${DOCS}

}


