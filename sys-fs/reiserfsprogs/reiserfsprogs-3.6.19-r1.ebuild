# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sys-fs/reiserfsprogs/reiserfsprogs-3.6.19-r1.ebuild,v 1.2 2007/12/26 15:31:05 armin76 Exp $

inherit eutils

DESCRIPTION="Reiserfs Utilities"
HOMEPAGE="http://www.namesys.com/"
SRC_URI="http://www.namesys.com/pub/reiserfsprogs/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="alpha amd64 arm hppa ia64 mips ppc ppc64 -sparc x86"
IUSE=""

src_unpack() {
	unpack ${A}
	cd "${S}"
	epatch "${FILESDIR}"/${P}-unaligned.patch
}

src_compile() {
	econf --prefix=/ || die "Failed to configure"
	emake || die "Failed to compile"
}

src_install() {
	emake DESTDIR="${D}" install || die "Failed to install"
	dosym reiserfsck /sbin/fsck.reiserfs
	dosym mkreiserfs /sbin/mkfs.reiserfs
	dodoc ChangeLog INSTALL README
}
