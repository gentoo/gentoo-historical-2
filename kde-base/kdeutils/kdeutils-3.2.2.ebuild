# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/kde-base/kdeutils/kdeutils-3.2.2.ebuild,v 1.13 2005/01/23 20:06:29 corsair Exp $

inherit kde-dist eutils

DESCRIPTION="KDE utilities"

KEYWORDS="x86 ppc sparc alpha hppa amd64 ~ia64 ~mips"
IUSE=""

DEPEND="~kde-base/kdebase-${PV}
	app-crypt/gnupg
	!app-crypt/kgpg"

src_unpack()
{
	kde_src_unpack
	epatch ${FILESDIR}/${P}-tarfix.patch
	epatch ${FILESDIR}/${P}-gcc34-compile.patch
}
