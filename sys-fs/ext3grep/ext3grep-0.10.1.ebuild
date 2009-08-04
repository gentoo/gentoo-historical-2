# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sys-fs/ext3grep/ext3grep-0.10.1.ebuild,v 1.2 2009/08/04 16:24:25 mr_bones_ Exp $

inherit eutils

DESCRIPTION="recover deleted files on an ext3 file system"
HOMEPAGE="http://www.xs4all.nl/~carlo17/howto/undelete_ext3.html"
SRC_URI="http://ext3grep.googlecode.com/files/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="debug pch"
DEPEND="virtual/libc"
RDEPEND="${DEPEND}"

src_unpack(){
	unpack ${A}
	cd "${S}"
	epatch "${FILESDIR}/${P}-gcc44.patch"
}

src_compile() {
	econf $(use_enable debug) \
		$(use_enable pch) || die "econd failed"

	emake || die "emake failed"
}

src_install() {
	emake DESTDIR="${D}" install || die
	dodoc NEWS README || die
}
