# Copyright 1999-2004 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sys-fs/reiserfsprogs/reiserfsprogs-3.6.13.ebuild,v 1.2 2004/04/13 22:51:49 kumba Exp $

inherit flag-o-matic eutils

DESCRIPTION="Reiserfs Utilities"
HOMEPAGE="http://www.namesys.com/"
SRC_URI="http://www.namesys.com/pub/${PN}/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~x86 ~amd64 mips ~ppc ~ppc64 ~sparc ~ia64 ~hppa"

src_compile() {
	filter-flags -fPIC
	econf --prefix=/ || die "Failed to configure"
	emake || die "Failed to compile"
}

src_install() {
	make DESTDIR="${D}" install || die "Failed to install"
	dodir /usr/share
	dodoc COPYING ChangeLog INSTALL README

	cd ${D}
	dosym /sbin/reiserfsck /sbin/fsck.reiserfs
}
