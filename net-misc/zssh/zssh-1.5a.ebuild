# Copyright 1999-2002 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License, v2 or later
# $Header: /var/cvsroot/gentoo-x86/net-misc/zssh/zssh-1.5a.ebuild,v 1.2 2002/12/23 02:31:53 joker Exp $

inherit eutils

IUSE=""
S=${WORKDIR}/${P}
DESCRIPTION="A ssh wrapper enabling zmodem up/download in ssh"
SRC_URI="ftp://ftp.sourceforge.net/pub/sourceforge/zssh/zssh-1.5a.tgz"
HOMEPAGE="http://zssh.sourceforge.net/"
KEYWORDS="~x86 sparc"
LICENSE="GPL-2"
SLOT="0"

DEPEND="virtual/glibc"
RDEPEND="virtual/glibc 
	 net-misc/openssh 
	 net-misc/lrzsz"

src_unpack() {
	unpack ${A}
	cd ${S}
	epatch ${FILESDIR}/${PF}-gentoo-termcap.diff
	epatch ${FILESDIR}/${PF}-gentoo-include.diff
}

src_compile() {
	local options

	use nls || options="${options} --disable-nls"
	use readline || options="${options} --disable-readline"

	./configure	\
		--prefix=/usr	\
		--host=${CHOST}	\
		${options} || die
	
	emake || die
}

src_install() {
	doman zssh.1
	doman ztelnet.1

	dobin zssh
	dobin ztelnet

	dodoc CHANGES FAQ README TODO
}

