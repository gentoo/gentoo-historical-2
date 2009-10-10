# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sys-fs/sshfs-fuse/sshfs-fuse-2.2.ebuild,v 1.6 2009/10/10 15:27:43 armin76 Exp $

EAPI="2"

inherit eutils

DESCRIPTION="Fuse-filesystem utilizing the sftp service."
SRC_URI="mirror://sourceforge/fuse/${P}.tar.gz"
HOMEPAGE="http://fuse.sourceforge.net/sshfs.html"

LICENSE="GPL-2"
KEYWORDS="amd64 ~hppa ppc ppc64 sparc x86 ~x86-fbsd"
SLOT="0"
IUSE=""

DEPEND=">=sys-fs/fuse-2.6.0_pre3
	>=dev-libs/glib-2.4.2"
RDEPEND="${DEPEND}
	>=net-misc/openssh-4.3"

src_configure() {
	# hack not needed with >=net-misc/openssh-4.3
	econf --disable-sshnodelay
}

src_install() {
	emake DESTDIR="${D}" install || die "emake install failed"
	dodoc README NEWS ChangeLog AUTHORS FAQ.txt || die
	doman sshfs.1 || die
}
