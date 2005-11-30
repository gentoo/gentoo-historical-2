# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-ftp/axyftp/axyftp-0.5.1.ebuild,v 1.1.1.1 2005/11/30 09:36:25 chriswhite Exp $

DESCRIPTION="GUI FTP client for X Window System (former WXftp)"
SRC_URI="http://www.wxftp.seul.org/download/${P}.tar.gz"
HOMEPAGE="http://www.wxftp.seul.org"

LICENSE="Artistic LGPL-2.1"
KEYWORDS="~x86 ~amd64 ~ppc"
SLOT="0"
IUSE=""

DEPEND=">=x11-libs/gtk+-1.2"

src_compile(){
	econf || die "configure failed"
	emake -j1 || die "compilation failed"
}

src_install() {
	make install DESTDIR=${D}
}
