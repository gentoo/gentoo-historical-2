# Copyright 1999-2003 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-shells/dsh/dsh-0.23.4-r2.ebuild,v 1.1 2003/08/11 18:20:56 vapier Exp $

DESCRIPTION="DSH - Distributed Shell"
SRC_URI="http://www.netfort.gr.jp/~dancer/software/downloads/${P}.tar.gz"
HOMEPAGE="http://www.netfort.gr.jp/~dancer/software/downloads/"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="x86 ppc"
IUSE="nls"

DEPEND="dev-libs/libdshconfig"
RDEPEND="net-misc/openssh"

src_compile() {
	econf --sysconfdir=/etc/dsh `use_enable nls` || die
	make || die
}

src_install() {
	make install DESTDIR=${D} || die
	dodir /etc/dsh/group
	dodoc TODO README ChangeLog
}
