# Copyright 1999-2003 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-portage/ufed/ufed-0.34.ebuild,v 1.2 2003/09/07 03:12:20 msterret Exp $

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
	newsbin ufed.pl ufed
	doman ufed.8
	dodoc COPYING ChangeLog
}
