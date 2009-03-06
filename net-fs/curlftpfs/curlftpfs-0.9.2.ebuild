# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-fs/curlftpfs/curlftpfs-0.9.2.ebuild,v 1.2 2009/03/06 07:15:04 fauli Exp $

DESCRIPTION="file system for accessing ftp hosts based on FUSE"
HOMEPAGE="http://curlftpfs.sourceforge.net/"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""
RESTRICT="test" # bug 258460

DEPEND=">=net-misc/curl-7.17.0
	>=sys-fs/fuse-2.2
	>=dev-libs/glib-2.0"
RDEPEND="${DEPEND}"

src_install() {
	emake DESTDIR="${D}" install || die
	dodoc README
}
