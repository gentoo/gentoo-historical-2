# Copyright 1999-2004 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-libs/libosip/libosip-0.9.7.ebuild,v 1.2 2004/04/11 22:22:03 kugelfang Exp $

DESCRIPTION="This is the oSIP library (for Open SIP). It has been designed to provide the Internet Community a simple way to support the Session Initiation Protocol.  SIP is described in the RFC2543 which is available at http://www.ietf.org/rfc/rfc2543.txt."
HOMEPAGE="http://www.linphone.org/?lang=us"
SRC_URI="http://osip.atosc.org/download/osip/${P}.tar.gz"

SLOT="1"
LICENSE="LGPL-2"
KEYWORDS="~x86 ~amd64"

DEPEND="virtual/glibc"

src_install () {
	einstall || die
	dodoc AUTHORS BUGS COPYING ChangeLog INSTALL NEWS README TODO
}
