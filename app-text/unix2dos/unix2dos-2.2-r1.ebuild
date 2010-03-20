# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-text/unix2dos/unix2dos-2.2-r1.ebuild,v 1.11 2010/03/20 16:12:11 jlec Exp $

inherit eutils toolchain-funcs

DESCRIPTION="UNIX to DOS text file format converter"
HOMEPAGE="http://www.xs4all.nl/~waterlan/dos2unix.html"
SRC_URI="mirror://gentoo/${P}.src.tar.gz"

LICENSE="BSD-2"
SLOT="0"
KEYWORDS="alpha amd64 arm hppa ~mips ppc ppc64 sh sparc x86 ~amd64-linux ~x86-linux ~ppc-macos ~x86-macos ~sparc-solaris ~sparc64-solaris"
IUSE=""

RDEPEND="!>=app-text/dos2unix-5"

S=${WORKDIR}

src_unpack() {
	unpack ${A}
	epatch "${FILESDIR}"/${PN}-mkstemp.patch
	epatch "${FILESDIR}"/${P}-segfault.patch
	epatch "${FILESDIR}"/${P}-manpage.patch
	epatch "${FILESDIR}"/${P}-workaround-rename-EXDEV.patch
	epatch "${FILESDIR}"/${P}-headers.patch
}

src_compile() {
	emake CC="$(tc-getCC)" unix2dos || die
}

src_install() {
	dobin unix2dos || die
	doman unix2dos.1
}
