# Copyright 1999-2003 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-misc/keychain/keychain-2.0.3.ebuild,v 1.6 2004/02/22 23:28:52 agriffis Exp $

DESCRIPTION="A front-end to ssh-agent"
HOMEPAGE="http://www.gentoo.org/proj/en/keychain.xml"

SRC_URI="http://www.ibiblio.org/gentoo/distfiles/${P}.tar.bz2"
S=${WORKDIR}/${P}
KEYWORDS="x86 ~ppc sparc ~alpha ~mips ~hppa amd64 ia64"
LICENSE="GPL-2"
SLOT="0"

DEPEND="virtual/glibc"
RDEPEND="${DEPEND} app-shells/bash net-misc/openssh
		|| ( sys-apps/coreutils sys-apps/sh-utils )"

src_install() {
	dobin keychain
	dodoc ChangeLog README
	doman keychain.1
}
