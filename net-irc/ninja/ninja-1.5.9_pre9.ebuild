# Copyright 1999-2004 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-irc/ninja/ninja-1.5.9_pre9.ebuild,v 1.7 2004/04/26 11:40:39 agriffis Exp $

# Get rid of underscore in package name
MY_PV=`echo ${PV} | sed -e 's/_.*//'`

S=${WORKDIR}/${PN}-${MY_PV}
DESCRIPTION="Ninja IRC Client"
HOMEPAGE="http://ninja.qoop.org/"
SRC_URI="http://ninja.qoop.org/ftp/sources/${P/_/}.tar.gz"
SLOT="0"
LICENSE="GPL-2"
KEYWORDS="x86 amd64 ~sparc"
IUSE="ncurses ipv6 ssl"
DEPEND="virtual/glibc
	ncurses? ( sys-libs/ncurses )
	ssl?  ( dev-libs/openssl )"

src_compile() {
	      local myconf
	      use ipv6 && myconf="${myconf} --enable-ipv6"
	      econf ${myconf} || die "econf failed"
	      emake || die "emake failed"
}

src_install() {
	      einstall
}

