# Copyright 1999-2003 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-dotnet/pnetc/pnetc-0.6.0.ebuild,v 1.2 2003/10/15 19:13:50 scandium Exp $

MY_P=${P/c/C}
S=${WORKDIR}/${MY_P}

DESCRIPTION="Portable .NET C library"
HOMEPAGE="http://www.dotgnu.org/"
SRC_URI="mirror://gnu/dotgnu-pnet/${MY_P}.tar.gz"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="~x86 ~ppc ~sparc"

IUSE=""

DEPEND="=dev-dotnet/pnetlib-${PV}*"

src_compile() {
	econf || die
	emake || die
}

src_install() {
	einstall || die

	dodoc AUTHORS COPYING ChangeLog INSTALL README doc/HACKING
}
