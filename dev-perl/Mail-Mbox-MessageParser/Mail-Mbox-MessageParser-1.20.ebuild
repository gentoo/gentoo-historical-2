# Copyright 1999-2004 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-perl/Mail-Mbox-MessageParser/Mail-Mbox-MessageParser-1.20.ebuild,v 1.1 2004/08/06 01:25:40 mcummings Exp $

inherit perl-module

S=${WORKDIR}/${P}
DESCRIPTION="Manipulation of electronic mail addresses"
SRC_URI="http://www.cpan.org/modules/by-module/Mail/DCOPPIT/${P}.tar.gz"
HOMEPAGE="http://www.cpan.org/~dcoppit/${P}/"

SLOT="0"
LICENSE="Artistic"
KEYWORDS="~x86"

DEPEND="${DEPEND}
	dev-perl/FileHandle-Unget"

src_compile() {
        echo "" | perl-module_src_compile
}
