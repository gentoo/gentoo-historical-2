# Copyright 1999-2003 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-misc/netkit-talk/netkit-talk-0.17-r2.ebuild,v 1.12 2003/02/13 15:01:43 vapier Exp $

A=netkit-ntalk-${PV}.tar.gz
S=${WORKDIR}/netkit-ntalk-${PV}
DESCRIPTION="Netkit - talkd"
SRC_URI="ftp://ftp.uk.linux.org/pub/linux/Networking/netkit/${A}"
HOMEPAGE="ftp://ftp.uk.linux.org/pub/linux/Networking/netkit/"
KEYWORDS="x86 ppc sparc alpha"
LICENSE="bsd"
SLOT="0"

DEPEND="virtual/glibc
	>=sys-libs/ncurses-5.2"

src_unpack() {
    unpack ${A}
    patch -p0 < ${FILESDIR}/${PF}-gentoo.diff
}

src_compile() {
    try ./configure
    cp MCONFIG MCONFIG.orig
    sed -e "s:-O2 -Wall:-Wall:" -e "s:-Wpointer-arith::" MCONFIG.orig > MCONFIG
    try make
}

src_install() {                               
	into /usr
	dobin  talk/talk
	doman  talk/talk.1
	dosbin talkd/talkd
	dosym  talkd /usr/sbin/in.talkd
	doman  talkd/talkd.8
	dosym  talkd.8.gz /usr/share/man/man8/in.talkd.8.gz
	dodoc  README ChangeLog BUGS
}


