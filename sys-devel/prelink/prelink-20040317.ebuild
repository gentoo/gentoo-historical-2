# Copyright 1999-2004 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sys-devel/prelink/prelink-20040317.ebuild,v 1.4 2004/04/13 10:08:02 cretin Exp $

inherit eutils

DESCRIPTION="Modifies executables so runtime libraries load faster"
HOMEPAGE="ftp://people.redhat.com/jakub/prelink"
SRC_URI="mirror://gentoo/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="x86 amd64 ppc alpha"

DEPEND=">=dev-libs/elfutils-0.94
	!dev-libs/libelf
	>=sys-libs/glibc-2.3.1
	>=sys-devel/binutils-2.13.90.0.10"

S=${WORKDIR}/${PN}

src_compile() {
	econf || die "Configure failed"
	emake || die "Make Failed"
}

src_install() {
	einstall || die "Install Failed"

	dodoc INSTALL TODO ChangeLog THANKS COPYING README AUTHORS NEWS

	insinto /etc
	doins ${S}/doc/prelink.conf
}
