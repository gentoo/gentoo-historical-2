# Copyright 1999-2003 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-portage/ufed/ufed-0.32.ebuild,v 1.1 2003/08/15 13:17:08 lanius Exp $

DESCRIPTION="Gentoo Linux USE flags editor"
HOMEPAGE="http://www.gentoo.org"
SRC_URI="mirror://gentoo/${P}.tar.bz2"	
LICENSE="GPL-2"
SLOT="0"
KEYWORDS="x86 ppc sparc hppa arm alpha"
IUSE=""

RDEPEND="dev-lang/perl
	dev-util/dialog
	dev-perl/TermReadKey"
DEPEND=""

S="${WORKDIR}/${P}"

src_install() {
	#--- start of fixes
	#the man bit is because of a bug I made in the tarball
	mv ${S}/docs/ufed.8 ${S}
	#remove CVS dirs for the moment
	find ${S} -name CVS -xtype d -exec rm -rf \{} \; 2>/dev/null
	#--- end of fixes
	
	newsbin ufed.pl ufed
	doman ufed.8
	dodoc COPYING docs/* ChangeLog
}
