# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sys-devel/prelink/prelink-20040317.ebuild,v 1.8 2005/01/10 18:32:39 ciaranm Exp $

inherit eutils

DESCRIPTION="Modifies executables so runtime libraries load faster"
HOMEPAGE="ftp://people.redhat.com/jakub/prelink"
SRC_URI="mirror://gentoo/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="x86 amd64 ppc alpha"
IUSE=""

DEPEND=">=dev-libs/elfutils-0.94
	!dev-libs/libelf
	>=sys-libs/glibc-2.3.2-r9
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

pkg_postinst() {
	echo
	einfo "You may wish to read the Gentoo Linux Prelink Guide, which can be"
	einfo "found online at:"
	einfo "    http://www.gentoo.org/doc/en/prelink-howto.xml"
	echo
}
