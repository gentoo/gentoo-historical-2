# Copyright 1999-2003 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-misc/mknbi/mknbi-1.4.3.ebuild,v 1.1 2003/12/08 12:34:16 mholzer Exp $

DESCRIPTION="Utility for making tagged kernel images useful for netbooting"
SRC_URI="mirror://sourceforge/etherboot/${P}.tar.gz"
RESTRICT="nomirror"
HOMEPAGE="http://etherboot.sourceforge.net"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="x86"

DEPEND=">=perl-5.6.1
	dev-lang/nasm"

S="${WORKDIR}/${P}"

src_compile()
{
	sed -i -e "s:\/usr\/local:\/usr:"  Makefile
	emake || die "Compile failed"
}

src_install()
{
	export BUILD_ROOT=${D}
	dodoc COPYING
	make DESTDIR=${D} install || "Installing failed"
}

