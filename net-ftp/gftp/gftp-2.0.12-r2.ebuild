# Copyright 1999-2002 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-ftp/gftp/gftp-2.0.12-r2.ebuild,v 1.2 2002/07/17 09:39:57 seemant Exp $

S=${WORKDIR}/${P}
DESCRIPTION="Gnome based FTP Client"
SRC_URI="http://www.gftp.org/${P}.tar.gz"
HOMEPAGE="http://www.gftp.org"

SLOT="0"
LICENSE="GPL-2"
KEYWORDS="x86"

# very generic depends. it should be that way.
DEPEND="virtual/x11
	gtk2? ( >=x11-libs/gtk+-2.0.0 )"

RDEPEND="nls? ( sys-devel/gettext )"

src_compile() {
	local myconf

	use nls || myconf="--disable-nls"
	use gtk2 && myconf="${myconf} --enable-gtk20" 

	econf ${myconf} || die
	emake || die
}

src_install() {

	make prefix=${D}/usr mandir=${D}/usr/share/man install || die

	dodoc COPYING ChangeLog README* THANKS TODO
	dodoc docs/USERS-GUIDE

}
