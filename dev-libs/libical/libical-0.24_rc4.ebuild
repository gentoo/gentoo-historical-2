# Copyright 1999-2004 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-libs/libical/libical-0.24_rc4.ebuild,v 1.5 2004/07/02 04:46:51 eradicator Exp $

IUSE=""

DESCRIPTION="libical is an implementation of basic iCAL protocols"
HOMEPAGE="http://softwarestudio.org/libical/"
SRC_URI="mirror://sourceforge/freeassociation/${PN}-0.24.RC4.tar.gz"

DEPEND="virtual/libc
			>=sys-devel/bison-1.35
			>=sys-devel/flex-2.5.4a-r5
			>=sys-apps/gawk-3.1.3
			>=dev-lang/perl-5.8.0-r12"

SLOT="0"
LICENSE="MPL-1.1 LGPL-2"
KEYWORDS="x86 ppc"

S=${WORKDIR}/libical-0.24

src_install () {
	einstall
}
