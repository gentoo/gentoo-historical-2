# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sys-fs/sshfs-fuse/sshfs-fuse-1.6.ebuild,v 1.8 2006/05/23 20:23:18 corsair Exp $

DESCRIPTION="Fuse-filesystem utilizing the sftp service."
SRC_URI="mirror://sourceforge/fuse/${P}.tar.gz"
HOMEPAGE="http://fuse.sourceforge.net/"
LICENSE="GPL-2"
DEPEND=">=sys-fs/fuse-2.2.1
	>=dev-libs/glib-2.4.2"
KEYWORDS="amd64 ppc ppc64 sparc x86 ~x86-fbsd"
SLOT="0"
IUSE=""

src_install () {
	make DESTDIR=${D} install || die "make install failed"
	dodoc README NEWS ChangeLog AUTHORS
}
