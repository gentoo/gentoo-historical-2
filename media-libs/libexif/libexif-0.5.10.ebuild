# Copyright 1999-2003 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-libs/libexif/libexif-0.5.10.ebuild,v 1.3 2003/09/07 13:16:13 obz Exp $

inherit flag-o-matic

IUSE="nls"

S=${WORKDIR}/${P}
DESCRIPTION="Library for parsing, editing, and saving EXIF data"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.gz"
HOMEPAGE="http://libexif.sf.net/"

SLOT="0"
LICENSE="LGPL-2.1"
KEYWORDS="x86 ~ppc ~sparc ~alpha"

DEPEND="dev-util/pkgconfig"

src_compile() {
	local myconf
	use nls || myconf="${myconf} --disable-nls"
	econf ${myconf}
	emake || die
}

src_install() {
	dodir /usr/lib
	dodir /usr/include/libexif
	dodir /usr/share/locale
	dodir /usr/lib/pkgconfig
	einstall || die

	dodoc ChangeLog README
}
