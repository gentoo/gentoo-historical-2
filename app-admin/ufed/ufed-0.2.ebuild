# Copyright 1999-2002 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-admin/ufed/ufed-0.2.ebuild,v 1.3 2003/02/11 22:13:01 gmsoft Exp $

DESCRIPTION="Gentoo Linux USE flags editor"
HOMEPAGE="http://www.gentoo.org"
SRC_URI="http://cvs.gentoo.org/~blizzy/${P}.tar.bz2"
LICENSE="GPL-2"
SLOT="0"
KEYWORDS="x86 ppc sparc hppa"
IUSE=""

RDEPEND="sys-devel/perl
	dev-util/dialog
	dev-perl/TermReadKey"
DEPEND=""

S="${WORKDIR}/${P}"

src_install() {
	newsbin ufed.pl ufed
}
