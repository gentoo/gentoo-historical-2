# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sys-fs/dosfstools/dosfstools-2.11-r1.ebuild,v 1.1 2005/11/15 00:42:34 vapier Exp $

inherit eutils

DESCRIPTION="DOS filesystem tools - provides mkdosfs, mkfs.msdos, mkfs.vfat"
HOMEPAGE="ftp://ftp.uni-erlangen.de/pub/Linux/LOCAL/dosfstools/"
SRC_URI="ftp://ftp.uni-erlangen.de/pub/Linux/LOCAL/dosfstools/${P}.src.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~hppa ~ia64 ~ppc ~sparc ~x86"
IUSE=""

DEPEND=""

src_unpack() {
	unpack ${A}
	cd "${S}"
	sed -i \
		-e '/^PREFIX/s:=:=/usr:' \
		-e '/^MANDIR/s:/usr:/share:' \
		Makefile || die "sed Makefile"
	epatch "${FILESDIR}"/dosfstools-2.11-fat32size.patch
}

src_compile() {
	# this package does *not* play well with optimisations
	# please dont change to: make OPTFLAGS="${CFLAGS}"
	emake -j1 || die
}

src_install() {
	make PREFIX="${D}"/usr install || die
	dodoc CHANGES TODO
	newdoc dosfsck/README README.dosfsck
	newdoc dosfsck/CHANGES CHANGES.dosfsck
	newdoc mkdosfs/README README.mkdosfs
	newdoc mkdosfs/ChangeLog ChangeLog.mkdosfs
}
