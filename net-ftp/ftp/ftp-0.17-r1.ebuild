# Copyright 1999-2002 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License, v2 or later
# $Header: /var/cvsroot/gentoo-x86/net-ftp/ftp/ftp-0.17-r1.ebuild,v 1.9 2002/08/16 14:24:47 murphy Exp $

MY_P=netkit-${P}
S=${WORKDIR}/${MY_P}
DESCRIPTION="Standard Linux FTP client"
SRC_URI="ftp://ftp.uk.linux.org/pub/linux/Networking/netkit/${MY_P}.tar.gz"

DEPEND="virtual/glibc
	>=sys-libs/ncurses-5.2"

SLOT="0"
LICENSE="as-is"
KEYWORDS="x86 ppc sparc sparc64"

src_compile() {			  
	
	./configure --prefix=/usr || die
	cp MCONFIG MCONFIG.orig
	sed -e "s/-pipe -O2/${CFLAGS}/" MCONFIG.orig > MCONFIG
	make || die
}

src_install() {							   
	into /usr
	dobin ftp/ftp
	doman ftp/ftp.1 ftp/netrc.5
	dodoc ChangeLog README BUGS
}
