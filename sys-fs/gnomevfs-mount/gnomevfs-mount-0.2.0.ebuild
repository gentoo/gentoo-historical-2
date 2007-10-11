# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sys-fs/gnomevfs-mount/gnomevfs-mount-0.2.0.ebuild,v 1.3 2007/10/11 12:20:33 swegener Exp $

WANT_AUTOMAKE="1.7"

inherit eutils flag-o-matic autotools

DESCRIPTION="A program for mounting gnome-vfs-uris onto the linux filesystem."
HOMEPAGE="http://primates.ximian.com/~sandino/gnomevfs-mount/"
SRC_URI="http://primates.ximian.com/~sandino/gnomevfs-mount/files/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND=">=sys-fs/fuse-2.2
	>=gnome-base/gnome-vfs-2.6.1.1"
RDEPEND="${DEPEND}"

pkg_setup() {
	append-lfs-flags
}

src_unpack() {
	unpack ${A}
	cd "${S}"

	epatch "${FILESDIR}"/gnomevfs-mount-as-needed.patch

	eautomake
}

src_install() {
	make DESTDIR="${D}" install || die "make install failed"
	dodoc AUTHORS ChangeLog README
}
