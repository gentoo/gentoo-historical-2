# Copyright 1999-2003 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-im/bitlbee/bitlbee-0.80.ebuild,v 1.6 2003/10/16 15:16:56 pyrania Exp $

inherit eutils

DESCRIPTION="Bitlbee is an irc to IM gateway that support multiple IM protocols"
HOMEPAGE="http://www.lintux.cx/bitlbee.html"
SRC_URI="http://www.lintux.cx/downloads/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="x86 sparc ~alpha"
IUSE=""

DEPEND="virtual/glibc"

src_unpack() {
	unpack ${P}.tar.gz

	# Patch the default xinetd file to add/adjust values to Gentoo defaults
	cd ${S}/doc
	epatch ${FILESDIR}/${P}-xinetd.patch
}

src_compile() {
	econf --datadir=/usr/share/bitlbee --etcdir=/etc
	emake || die "make failed"

	# make bitlbeed forking server
	cd utils
	[ -n "${CC}" ] \
		&& ${CC} ${CFLAGS} bitlbeed.c -o bitlbeed \
		|| gcc ${CFLAGS} bitlbeed.c -o bitlbeed

}

src_install() {
	mkdir -p ${D}/var/lib/bitlbee
	make install DESTDIR=${D} || die "install failed"

	dodoc COPYING
	dodoc doc/{AUTHORS,CHANGES,CREDITS,FAQ,README,TODO}
	dohtml -A sgml doc/*.sgml
	doman doc/bitlbee.8

	dobin utils/bitlbeed

	insinto /etc/xinetd.d
	newins doc/bitlbee.xinetd bitlbee
}

pkg_postinst() {
	chown nobody:nobody /var/lib/bitlbee
	chmod 700 /var/lib/bitlbee
}
