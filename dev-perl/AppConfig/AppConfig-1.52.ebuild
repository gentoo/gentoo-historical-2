# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-perl/AppConfig/AppConfig-1.52.ebuild,v 1.15 2005/03/09 18:20:48 corsair Exp $

inherit perl-module

DESCRIPTION="The Perl CGI Module"
SRC_URI="http://www.cpan.org/authors/id/ABW/${P}.tar.gz"
HOMEPAGE="http://search.cpan.org/author/ABW/AppConfig-1.52/"

SLOT="0"
LICENSE="|| ( Artistic GPL-2 )"
KEYWORDS="x86 amd64 sparc alpha ppc"
IUSE=""

src_unpack() {
	unpack ${A}
	patch -p0 < ${FILESDIR}/${P}-gentoo.diff
}
src_install() {
	mydoc="TODO"
	perl-module_src_install
}
