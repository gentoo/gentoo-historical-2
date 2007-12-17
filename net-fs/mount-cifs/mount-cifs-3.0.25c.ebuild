# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-fs/mount-cifs/mount-cifs-3.0.25c.ebuild,v 1.6 2007/12/17 22:03:21 jer Exp $

inherit toolchain-funcs

DESCRIPTION="cifs filesystem mount helper split from Samba"
HOMEPAGE="http://linux-cifs.samba.org/cifs/cifs_download.html"
SRC_URI="mirror://gentoo/${P}.tar.gz
	http://dev.gentooexperimental.org/~jakub/distfiles/${P}.tar.gz"
LICENSE="GPL-2"
SLOT="0"
KEYWORDS="alpha amd64 hppa ia64 ppc64 sparc x86"
IUSE=""

DEPEND="!<net-fs/samba-3.0.25"
RDEPEND="${DEPEND}"

src_compile() {
	cd "${S}/source/client"
	$(tc-getCC) ${CFLAGS} mount.cifs.c -o mount.cifs || die "make mount.cifs failed"
	$(tc-getCC) ${CFLAGS} umount.cifs.c -o umount.cifs || die "make umount.cifs failed"
}

src_install() {
	dobin source/client/{mount,umount}.cifs
	dosym /usr/bin/mount.cifs /sbin/mount.cifs

	docinto html
	dohtml docs/htmldocs/*
	doman docs/manpages/{mount,umount}.cifs.8
}
