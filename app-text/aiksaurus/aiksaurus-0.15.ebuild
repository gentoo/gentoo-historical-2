# Copyright 1999-2003 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-text/aiksaurus/aiksaurus-0.15.ebuild,v 1.6 2003/02/13 09:32:27 vapier Exp $

S=${WORKDIR}/Aiksaurus-${PV}
DESCRIPTION="A thesaurus lib, tool and database"
SRC_URI="http://www.aiksaurus.com/dist/TAR/Aiksaurus-${PV}.tar.gz"
HOMEPAGE="http://www.aiksaurus.com/"
SLOT="0"
LICENSE="GPL-2"

DEPEND="sys-devel/gcc"
RDEPEND=""
KEYWORDS="x86 ppc sparc "
src_compile() {
    cd ${S}
    ./configure --prefix=/usr || die
    emake || die
}

src_install() {

    make DESTDIR=${D} install || die

}
