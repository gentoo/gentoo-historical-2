# Copyright 1999-2003 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-shells/dsh/dsh-0.25.0.ebuild,v 1.1 2003/10/02 17:20:52 vapier Exp $

DESCRIPTION="DSH - Distributed Shell"
HOMEPAGE="http://www.netfort.gr.jp/~dancer/software/downloads/"
SRC_URI="http://www.netfort.gr.jp/~dancer/software/downloads/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~x86 ~ppc"
IUSE="nls"

DEPEND="dev-libs/libdshconfig"
RDEPEND="virtual/ssh"

src_compile() {
	econf --sysconfdir=/etc/dsh `use_enable nls` || die
	make || die
}

src_install() {
	make install DESTDIR=${D} || die
	dodir /etc/dsh/group
	dodoc TODO README ChangeLog
}
