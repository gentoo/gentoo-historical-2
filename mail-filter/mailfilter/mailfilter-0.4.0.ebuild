# Copyright 1999-2004 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/mail-filter/mailfilter/mailfilter-0.4.0.ebuild,v 1.3 2004/07/01 19:51:15 eradicator Exp $

IUSE="nls"

S=${WORKDIR}/${P}
DESCRIPTION="Mailfilter is a utility to get rid of unwanted spam mails"
SRC_URI="mirror://sourceforge/mailfilter/${P}.tar.gz"
HOMEPAGE="http://mailfilter.sourceforge.net/index.html"

DEPEND="virtual/libc"
RDEPEND="nls? ( sys-devel/gettext )"

SLOT="0"
LICENSE="GPL-2"
KEYWORDS="x86 sparc"

src_compile() {

	local myconf
	use nls || myconf="${myconf} --disable-nls"

	./configure \
		--host=${CHOST} \
		--prefix=/usr \
		--infodir=/usr/share/info \
		--mandir=/usr/share/man ${myconf} || die "./configure failed"
	make || die
}

src_install () {

	make DESTDIR=${D} install || die
	dodoc INSTALL doc/FAQ doc/rcfile.example1 doc/rcfile.example2
	dodoc README THANKS ChangeLog AUTHORS NEWS TODO

}
