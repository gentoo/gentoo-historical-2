# Copyright 1999-2004 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/kde-base/kdeutils/kdeutils-3.2.2.ebuild,v 1.7 2004/05/24 03:07:07 dostrow Exp $

inherit kde-dist eutils

DESCRIPTION="KDE utilities"

KEYWORDS="x86 ppc sparc ~alpha ~hppa ~amd64 ~ia64 ~mips"

DEPEND="~kde-base/kdebase-${PV}
	app-crypt/gnupg
	!app-crypt/kgpg"

src_unpack()
{
	kde_src_unpack
	epatch ${FILESDIR}/${P}-tarfix.patch
	epatch ${FILESDIR}/${P}-gcc34-compile.patch
}
