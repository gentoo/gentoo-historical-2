# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-admin/sus/sus-2.0.6.ebuild,v 1.5 2005/06/05 11:27:39 hansmi Exp $

inherit toolchain-funcs

DESCRIPTION="allows certain users to run commands as root or other users"
HOMEPAGE="http://pdg.uow.edu.au/sus/"
SRC_URI="http://pdg.uow.edu.au/sus/${P}.tar.Z"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="mips ppc sparc x86"
IUSE="pam"

DEPEND="virtual/libc
	pam? ( >=sys-libs/pam-0.73-r1 )"


src_compile() {
	local myconf
	local lflags
	myconf="-DDEBUG"
	use pam && myconf="${myconf} -DUSE_PAM" && lflags="-lpam"
	myconf="${myconf} -DPROMISCUOUS -DUSE_SHADOW \
		-DSUSERS=\\\"/etc/susers.cpp\\\""
	make \
		CC=$(tc-getCC) \
		CFLAGS="${CFLAGS} ${myconf}" \
		LFLAGS="${lflags}" \
		sus || die
}

src_install() {
	dobin sus || die
	newman man/sus.1 sus.8
	dodoc INSTALL README susers.sample
	dodir /var/run/sus
	insinto /etc
	newins ${FILESDIR}/susers.cpp susers.cpp
	fperms 4755 /usr/bin/sus
	fperms 700 /var/run/sus
	insinto /etc
	doins ${FILESDIR}/susers.cpp
}

pkg_postinst() {
	einfo "A default configuration file has been installed as"
	einfo "/etc/susers.cpp.  It is best to read over it and"
	einfo "make any changes as necessary."
}
