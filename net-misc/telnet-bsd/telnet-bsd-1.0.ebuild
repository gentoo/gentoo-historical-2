# Copyright 2002 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License, v2 or later
# $Header: /var/cvsroot/gentoo-x86/net-misc/telnet-bsd/telnet-bsd-1.0.ebuild,v 1.3 2003/01/07 05:37:31 bcowan Exp $

IUSE=""
S=${WORKDIR}/${P}

inherit eutils
EPATCH_SOURCE="${FILESDIR}"

DESCRIPTION="Telnet and telnetd ported from OpenBSD with IPv6 support"
SRC_URI="ftp://ftp.suse.com/pub/people/kukuk/ipv6/${P}.tar.bz2"
HOMEPAGE="ftp://ftp.suse.com/pub/people/kukuk/ipv6/"

DEPEND="virtual/glibc"

KEYWORDS="x86"
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
