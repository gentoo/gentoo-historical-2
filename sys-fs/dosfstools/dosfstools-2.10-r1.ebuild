# Copyright 1999-2004 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sys-fs/dosfstools/dosfstools-2.10-r1.ebuild,v 1.8 2004/09/07 22:55:43 vapier Exp $

inherit eutils flag-o-matic

DESCRIPTION="DOS filesystem tools - provides mkdosfs, mkfs.msdos, mkfs.vfat"
HOMEPAGE="ftp://ftp.uni-erlangen.de/pub/Linux/LOCAL/dosfstools/"
SRC_URI="ftp://ftp.uni-erlangen.de/pub/Linux/LOCAL/dosfstools/${P}.src.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="x86 ppc sparc alpha hppa amd64 ia64"
IUSE=""

DEPEND="virtual/libc"

src_unpack() {
	unpack ${A}; cd ${S}
	epatch ${FILESDIR}/errno.patch
	epatch ${FILESDIR}/${P}-2.6.headers.patch
	epatch ${FILESDIR}/${P}-lseek64.patch
	sed -i "s:PREFIX\ \=:PREFIX\ \=\ \/usr:" Makefile
	sed	-i "s:\/usr\/man:\/share\/man:" Makefile
}

src_compile() {
	# we no longer need to filter fPIC on this package thanks to the
	# lseek64.patch from bug #51962

	# this package does *not* play well with optimisations
	# please dont change to: make OPTFLAGS="${CFLAGS}"
	make || die
}

src_install() {
	make PREFIX=${D}/usr install || die
	dodoc CHANGES TODO
	newdoc dosfsck/README README.dosfsck
	newdoc dosfsck/CHANGES CHANGES.dosfsck
	newdoc dosfsck/COPYING COPYING.dosfsck
	newdoc mkdosfs/README README.mkdosfs
	newdoc mkdosfs/ChangeLog ChangeLog.mkdosfs
}
