# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-dialup/minicom/minicom-2.1-r1.ebuild,v 1.12 2005/04/20 22:11:07 mrness Exp $

inherit eutils

DESCRIPTION="Serial Communication Program"
HOMEPAGE="http://alioth.debian.org/projects/minicom"
SRC_URI="http://alioth.debian.org/download.php/123/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="alpha amd64 arm hppa ia64 ~mips ppc sparc x86"
IUSE=""

DEPEND=">=sys-libs/ncurses-5.2-r3"
RDEPEND="${DEPEND}
	net-dialup/lrzsz"

src_unpack() {
	unpack ${A}
	cd ${S}
	# solar@gentoo.org (Mar 24 2004)
	# propolice/ssp caught minicom going out of bounds here.
	epatch ${FILESDIR}/${PN}-2.1-memcpy-bounds.diff
}

src_compile() {
	econf --sysconfdir=/etc/${PN} || die "econf failed"
	emake || die "emake failed"
}

src_install() {
	einstall || die "einstall failed"
	dodoc doc/minicom.FAQ
	insinto /etc/minicom
	doins ${FILESDIR}/minirc.dfl

	dodoc AUTHORS COPYING ChangeLog INSTALL NEWS README
}
