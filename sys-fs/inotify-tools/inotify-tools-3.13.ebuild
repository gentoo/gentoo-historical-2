# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sys-fs/inotify-tools/inotify-tools-3.13.ebuild,v 1.2 2008/06/01 09:08:17 wschlich Exp $

IUSE=""
DESCRIPTION="a set of command-line programs providing a simple interface to inotify"
HOMEPAGE="http://inotify-tools.sourceforge.net/"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.gz"
LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~hppa ~x86"
DEPEND="virtual/libc"

src_install() {
	emake DESTDIR="${D}" install || die "make install failed"
	dodoc NEWS AUTHORS
}
