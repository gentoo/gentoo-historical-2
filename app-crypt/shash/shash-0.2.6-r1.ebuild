# Copyright 1999-2004 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-crypt/shash/shash-0.2.6-r1.ebuild,v 1.3 2004/11/06 13:33:50 swegener Exp $

inherit bash-completion

DESCRIPTION="Generate or check digests or MACs of files"
HOMEPAGE="http://mcrypt.hellug.gr/shash/"
SRC_URI="ftp://mcrypt.hellug.gr/pub/mcrypt/${PN}/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="x86 ~ppc"
IUSE="static"

RDEPEND="virtual/libc
	>=app-crypt/mhash-0.8.18-r1"
DEPEND="${RDEPEND}
	sys-devel/libtool
	sys-devel/automake
	sys-devel/autoconf
	sys-apps/gawk"

src_unpack() {
	unpack ${A}
	cd ${S}

	epatch ${FILESDIR}/0.2.6-manpage-fixes.patch
}

src_compile() {
	econf $(use_enable static static-link) || die "econf failed"
	emake || die "emake failed"
}

src_install() {
	make install DESTDIR=${D} || die "install failed"
	dodoc AUTHORS ChangeLog INSTALL NEWS doc/sample.shashrc doc/FORMAT
	dobashcompletion ${FILESDIR}/shash.bash-completion ${PN}
}
