# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-ftp/tnftp/tnftp-20050103.ebuild,v 1.1 2005/01/08 20:16:39 g2boojum Exp $

DESCRIPTION="NetBSD FTP client with several advanced features"
SRC_URI="ftp://ftp.netbsd.org/pub/NetBSD/misc/${PN}/${P}.tar.gz"
HOMEPAGE="ftp://ftp.netbsd.org/pub/NetBSD/misc/tnftp/"
DEPEND="virtual/libc >=sys-libs/ncurses-5.1"

SLOT="0"
LICENSE="as-is"
KEYWORDS="x86 ~sparc ~ppc ~alpha ~amd64"
IUSE="ipv6"

src_unpack() {
	unpack ${A}
	cd ${S}
	# Adds a command line option: -s, which produces clean, informative output.
	# Shows progess status, ETA, transfer speed, no server responses or login messages.
	# ~woodchip
	cp src/main.c src/main.orig
	sed -e "s/46AadefginN:o:pP:q:r:RtT:u:vV/46AadefginN:o:pP:r:RstT:u:vV/" \
		-e "s/case 't'/case 's':\n\t\t\tverbose = 0;\n\t\t\tprogress = 1;\n\t\t\tbreak;\n\n\t\t&/" \
		src/main.orig > src/main.c || die "sed failed in src_unpack"
}

src_compile() {
	local myconf
	use ipv6 || myconf="${myconf} --disable-ipv6"
	./configure \
		--prefix=/usr \
		--enable-editcomplete \
		--host=${CHOST} ${myconf} || die "bad ./configure"
	emake || die "compile problem"
}

src_install() {
	dodoc COPYING ChangeLog README* THANKS NEWS
	newbin src/ftp tnftp
	newman src/ftp.1 tnftp.1
	if [ ! -e /usr/bin/ftp ]
	then
		cd ${D}/usr/bin
		ln -s tnftp ftp
	fi
	if [ ! -e /usr/bin/lukemftp ]
	then
		cd ${D}/usr/bin
		ln -s tnftp lukemftp
	fi
}
