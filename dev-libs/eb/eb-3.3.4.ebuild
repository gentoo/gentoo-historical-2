# Copyright 1999-2004 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-libs/eb/eb-3.3.4.ebuild,v 1.5 2004/06/24 23:07:59 agriffis Exp $

IUSE="nls"

DESCRIPTION="EB is a C library and utilities for accessing CD-ROM books"
HOMEPAGE="http://www.sra.co.jp/people/m-kasahr/eb/"
SRC_URI="ftp://ftp.sra.co.jp/pub/misc/eb/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="x86"

DEPEND="virtual/glibc
	sys-libs/zlib
	nls? ( sys-devel/gettext )"

src_compile () {

	econf `use_enable nls` || die
	emake || die
}

src_install () {

	einstall || die

	dodoc AUTHORS INSTALL* NEWS README*
}
