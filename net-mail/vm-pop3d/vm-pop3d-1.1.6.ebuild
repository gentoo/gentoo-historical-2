# Copyright 1999-2003 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-mail/vm-pop3d/vm-pop3d-1.1.6.ebuild,v 1.8 2003/08/03 03:45:46 vapier Exp $

DESCRIPTION="POP3 server"
HOMEPAGE="http://www.reedmedia.net/software/virtualmail-pop3d/"
SRC_URI="http://www.ibiblio.org/pub/Linux/system/mail/pop/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="x86 sparc"
IUSE="pam debug"

DEPEND="virtual/glibc
	pam? ( sys-libs/pam )"

src_unpack() {
	unpack ${A}
	cd ${S}
	epatch ${FILESDIR}/makefile.in.diff
}

src_compile() {
	econf \
		`use_enable pam` \
		`use_enable debug` \
		|| die "configure failed"
	emake || die "make failed"
}

src_install() {
	einstall || die "make install failed"

	dodoc AUTHORS CHANGES COPYING FAQ INSTALL README TODO

        exeinto /etc/init.d
        newexe ${FILESDIR}/vm-pop3d.rc3 vm-pop3d
        insinto /etc/conf.d
        newins ${FILESDIR}/vm-pop3d.confd vm-pop3d
}
