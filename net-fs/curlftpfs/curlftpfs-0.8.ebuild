# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-fs/curlftpfs/curlftpfs-0.8.ebuild,v 1.1 2006/05/27 13:16:01 genstef Exp $

DESCRIPTION="CurlFtpFS is a filesystem for acessing ftp hosts based on FUSE"
HOMEPAGE="http://curlftpfs.sourceforge.net"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~x86"
IUSE=""

RDEPEND=">=net-misc/curl-7.15.2
	>=sys-fs/fuse-2.2"

src_install() {
	make DESTDIR=${D} install || die "make install failed"
	dodoc README
}
