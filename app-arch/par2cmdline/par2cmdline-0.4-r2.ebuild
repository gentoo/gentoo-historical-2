# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-arch/par2cmdline/par2cmdline-0.4-r2.ebuild,v 1.7 2010/01/15 01:30:02 abcd Exp $

inherit eutils

DESCRIPTION="A PAR-2.0 file verification and repair tool"
HOMEPAGE="http://parchive.sourceforge.net/"
SRC_URI="mirror://sourceforge/parchive/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ~hppa ppc ~ppc64 x86 ~x86-interix ~amd64-linux ~x86-linux ~ppc-macos ~x86-macos"
IUSE=""

DEPEND=""

src_unpack() {
	unpack ${A}
	cd "${S}"

	epatch "${FILESDIR}"/${P}-wildcard-fix.patch
	epatch "${FILESDIR}"/${P}-offset.patch
	epatch "${FILESDIR}"/${P}-letype.patch
	epatch "${FILESDIR}"/${P}-gcc4.patch
}

src_install() {
	make install DESTDIR="${D}" || die "make install failed"
	# Replace the hardlinks with symlinks
	dosym par2 /usr/bin/par2create
	dosym par2 /usr/bin/par2repair
	dosym par2 /usr/bin/par2verify
	dodoc AUTHORS ChangeLog README
}
