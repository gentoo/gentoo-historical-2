# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sys-fs/jfsutils/jfsutils-1.1.14.ebuild,v 1.5 2009/09/27 17:12:34 nixnut Exp $

inherit eutils flag-o-matic

DESCRIPTION="IBM's Journaling Filesystem (JFS) Utilities"
HOMEPAGE="http://jfs.sourceforge.net/"
SRC_URI="http://jfs.sourceforge.net/project/pub/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~alpha amd64 arm ~hppa ia64 ~mips ppc ppc64 s390 sh ~sparc x86"
IUSE="static"

DEPEND="virtual/libc"

src_compile() {
	# It doesn't compile on alpha without this LDFLAGS
	use alpha && append-ldflags "-Wl,--no-relax"

	use static && append-ldflags -static
	econf --sbindir=/sbin || die "econf failed"
	emake || die "emake failed"
}

src_install () {
	make DESTDIR="${D}" install || die

	rm -f "${D}"/sbin/mkfs.jfs fsck.jfs
	dosym /sbin/jfs_mkfs /sbin/mkfs.jfs
	dosym /sbin/jfs_fsck /sbin/fsck.jfs

	dodoc AUTHORS ChangeLog NEWS README
}
