# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sys-apps/tinylogin/tinylogin-1.4.ebuild,v 1.10 2005/01/26 23:51:47 xmerlin Exp $

DESCRIPTION="worlds smallest login/passwd/getty/etc"
HOMEPAGE="http://tinylogin.busybox.net/"
SRC_URI="http://tinylogin.busybox.net/downloads/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="x86 arm amd64"
IUSE="static"

DEPEND="virtual/libc"

RDEPEND="!static? ( virtual/libc )
	!sys-apps/pam-login
	!sys-apps/shadow
	!sys-apps/sysvinit
	"

src_compile() {
	local myconf=""
	use static && myconf="${myconf} DOSTATIC=true"

	emake ${myconf} || die
}

src_install() {
	emake PREFIX=${D} install || die

	doman docs/*.{1,8}

	dodoc Changelog README TODO
	cd docs
	dodoc *.txt
	dohtml -r tinylogin.busybox.net
	docinto pod
	dodoc *.pod
}

