# Copyright 1999-2003 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-emulation/mol/mol-0.9.65.ebuild,v 1.8 2003/02/13 07:14:40 vapier Exp $

inherit flag-o-matic

S=${WORKDIR}/${P}
DESCRIPTION="MOL (Mac-on-Linux) is a PPC-only program to run Mac OS X and under natively within Linux"
SRC_URI="ftp://ftp.nada.kth.se/pub/home/f95-sry/Public/mac-on-linux/${P}.tgz"
HOMEPAGE="http://www.maconlinux.net/"

DEPEND="virtual/glibc"
RDEPEND=""
SLOT="0"
LICENSE="GPL-2"
KEYWORDS="ppc -x86 -sparc  -alpha"
IUSE=""

src_compile() {

	filter-flags -fsigned-char
	./configure --prefix=/usr || die "This is a ppc-only package (time to buy that iBook, no?)"
	emake || die "Failed to compile MOL"
}

src_install() {

	emake DESTDIR=${D} install || die "Failed to install MOL"

	dodoc 0README BUILDING COPYING COPYRIGHT CREDITS Doc/*

}

pkg_postinst() {
	einfo "Mac-on-Linux is now installed.  To run, use the command startmol"
	einfo "You might want to configure video modes first with molvconfig"
	einfo "Other configuration is in /etc/molrc.  For more info see:"
	einfo "              www.maconlinux.net"
	einfo "Also try man molrc, man molvconfig, man startmol"
}
