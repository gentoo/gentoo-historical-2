# Copyright 1999-2004 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-libs/libexif/libexif-0.6.10.ebuild,v 1.1 2004/09/27 17:41:22 sekretarz Exp $

inherit flag-o-matic

IUSE="nls"

DESCRIPTION="Library for parsing, editing, and saving EXIF data"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.gz"
HOMEPAGE="http://libexif.sf.net/"

SLOT="0"
LICENSE="LGPL-2.1"
KEYWORDS="~x86 ~ppc ~sparc ~alpha ~hppa ~amd64 ~ia64 ~mips ~ppc64"

DEPEND="dev-util/pkgconfig"
RDEPEND="virtual/libc"

src_compile() {
	econf `use_enable nls` || die
	emake || die
}

src_install() {
	dodir /usr/lib
	dodir /usr/include/libexif
	use nls && dodir /usr/share/locale
	dodir /usr/lib/pkgconfig
	einstall || die

	dodoc ChangeLog README

	# installs a blank directory for whatever broken reason
	use nls || rm -rf ${D}/usr/share/locale
}
