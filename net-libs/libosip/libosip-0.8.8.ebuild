# Copyright 1999-2003 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-libs/libosip/libosip-0.8.8.ebuild,v 1.5 2004/02/22 23:05:20 agriffis Exp $

DESCRIPTION="This is the oSIP library (for Open SIP). It has been designed to provide the Internet Community a simple way to support the Session Initiation Protocol.  SIP is described in the RFC2543 which is available at http://www.ietf.org/rfc/rfc2543.txt."
HOMEPAGE="http://www.linphone.org/?lang=us"
SRC_URI="http://www.linphone.org/download/${P}.tar.gz"

SLOT="1"
LICENSE="LGPL-2"
KEYWORDS="x86 ~ppc ~sparc ~alpha ~mips ~hppa "

DEPEND="virtual/glibc"

src_install () {
	einstall || die
	dodoc AUTHORS BUGS COPYING ChangeLog INSTALL NEWS README TODO
}
