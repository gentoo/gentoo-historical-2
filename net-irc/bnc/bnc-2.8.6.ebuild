# Copyright 1999-2004 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-irc/bnc/bnc-2.8.6.ebuild,v 1.15 2004/06/24 23:02:01 agriffis Exp $

inherit eutils

MY_P=${P/-/}
DESCRIPTION="BNC (BouNCe) is used as a gateway to an IRC Server"
HOMEPAGE="http://gotbnc.com/"
SRC_URI="http://gotbnc.com/files/${MY_P}.tar.gz
	http://bnc.ircadmin.net/${MY_P}.tar.gz
	ftp://ftp.ircadmin.net/bnc/${MY_P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="x86 ppc sparc alpha arm"
IUSE=""

DEPEND="virtual/glibc"

S=${WORKDIR}/${MY_P}

src_compile() {
	# fix gcc-3.4 compilation, bug #54689.
	epatch ${FILESDIR}/bnc-2.8.6-gotofail-labelfix.patch
	econf || die
	emake || die
	mv mkpasswd bncmkpasswd
}

src_install() {
	dodoc CHANGES README
	dobin bnc bncchk bncsetup bncmkpasswd || die
	insinto /usr/share/${MY_P}
	doins example.conf motd
}

pkg_postinst() {
	einfo "You can find an example motd/conf file here:"
	einfo " /usr/share/${MY_P}/{example.conf,motd}"
}
