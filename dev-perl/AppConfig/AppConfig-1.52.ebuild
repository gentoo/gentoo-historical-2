# Copyright 1999-2002 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License, v2 or later
# $Header: /var/cvsroot/gentoo-x86/dev-perl/AppConfig/AppConfig-1.52.ebuild,v 1.1 2002/08/06 21:06:20 achim Exp $

inherit perl-module

S=${WORKDIR}/${P}
DESCRIPTION="The Perl CGI Module"
SRC_URI="http://www.cpan.org/authors/id/ABW/${P}.tar.gz"

SLOT="0"
LICENSE="Artistic | GPL-2"
KEYWORDS="x86"

src_unpack() {
	unpack ${A}
	patch -p0 < ${FILESDIR}/${P}-gentoo.diff
}
src_install() {
	mydoc="TODO"
	perl-module_src_install
}
