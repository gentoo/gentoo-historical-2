# Copyright 1999-2003 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-misc/telnet-bsd/telnet-bsd-1.0.ebuild,v 1.11 2003/11/25 03:35:57 agriffis Exp $

IUSE=""
S=${WORKDIR}/${P}

inherit eutils
EPATCH_SOURCE="${FILESDIR}"

DESCRIPTION="Telnet and telnetd ported from OpenBSD with IPv6 support"
SRC_URI="ftp://ftp.suse.com/pub/people/kukuk/ipv6/${P}.tar.bz2"
HOMEPAGE="ftp://ftp.suse.com/pub/people/kukuk/ipv6/"

DEPEND="virtual/glibc"

KEYWORDS="x86 sparc hppa ~ppc alpha"
SLOT="0"
LICENSE="BSD"


src_unpack() {
	unpack ${A}
	cd ${S}
	epatch
}

src_compile() {
	econf
	emake || die
}

src_install () {
	einstall

	dodoc README THANKS NEWS COPYING AUTHORS ChangeLog INSTALL ABOUT-NLS
}
