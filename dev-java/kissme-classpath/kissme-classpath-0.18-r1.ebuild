# Copyright 1999-2001 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License, v2 or later
# $Header: /var/cvsroot/gentoo-x86/dev-java/kissme-classpath/kissme-classpath-0.18-r1.ebuild,v 1.4 2002/07/11 06:30:19 drobbins Exp $

S=${WORKDIR}/${P}

DESCRIPTION="GNU Classpath specifically tailored to kissme"

SRC_URI="mirror://sourceforge/kissme/kissme-classpath-0.18.tar.gz"

HOMEPAGE="http://www.gnu.org/software/classpath/classpath.html"

DEPEND=">=virtual/jdk-1.3
        >=dev-java/jikes-1.13
        app-shells/zsh"
        
RDEPEND=""

src_compile() {
    make build || die
}

src_install () {
    dodir usr/share/kissme/classpath
    dodoc src/README
    DESTDIR=${D} sh install.sh || die
    echo "/usr/share/kissme/classpath" > ${D}/usr/share/kissme/classpath.env
}

