# Copyright 1999-2003 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-misc/dante/dante-1.1.13.ebuild,v 1.9 2003/02/13 14:47:51 vapier Exp $

IUSE="tcpd"

S=${WORKDIR}/${P}
DESCRIPTION="A free socks4,5 and msproxy implemetation"
SRC_URI="ftp://ftp.inet.no/pub/socks/${P}.tar.gz"
HOMEPAGE="http://www.inet.no/dante/"

LICENSE="BSD"
KEYWORDS="~x86 ~sparc ~ppc"
SLOT="0"

RDEPEND="virtual/glibc
	sys-libs/pam
	tcpd? ( sys-apps/tcp-wrappers )"

DEPEND="${RDEPEND}
	sys-devel/perl"

# removed the src_unpack() since it doesn't appear to need any of those
# patches (they all barfed when I tried to apply them by hand)

src_compile() {
	local myconf
	use tcpd || myconf="--disable-libwrap"
	[ -n "$DEBUGBUILD" ] || myconf="${myconf} --disable-debug"
	einfo "myconf is $myconf"
	./configure \
		--prefix=/usr \
		--mandir=/usr/share/man \
		--with-socks-conf=/etc/socks/socks.conf \
		--with-sockd-conf=/etc/socks/sockd.conf \
		--host=${CHOST} ${myconf} || die "bad ./configure"
	emake || die "compile problem"
}

src_install() {
	# Line 99 in socks.h conflicts with stuff in line 333 of
	# /usr/include/netinet/in.h this is a not-too-cool way of fix0ring that
	cat capi/socks.h | \
		sed -e "s:^int Rbindresvport://int Rbindresvport:" > capi/socks.h
	make DESTDIR=${D} install || die
	# bor: comment libdl.so out it seems to work just fine without it
	perl -pe 's/(libdl\.so)//' -i ${D}/usr/bin/socksify
	dodir /etc/socks
	dodoc BUGS CREDITS LICENSE NEWS README SUPPORT TODO VERSION 
	docinto txt
	cd doc
	dodoc README* *.txt SOCKS4.*
	docinto example
	cd ../example
	dodoc *.conf
	exeinto /etc/init.d
	newexe ${FILESDIR}/dante-sockd-init dante-sockd
}
