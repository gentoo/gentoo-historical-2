# Copyright 1999-2003 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sys-libs/detect/detect-0.9.72.ebuild,v 1.2 2003/02/13 16:48:25 vapier Exp $

DESCRIPTION="Detect is a library for automatic hardware detection."
HOMEPAGE="http://www.mandrakelinux.com/harddrake/index.php"
SRC_URI="http://ftp.debian.org/debian/pool/main/d/detect/${P//-/_}.orig.tar.gz 
http://ftp.debian.org/debian/pool/main/d/detect/${P//-/_}-6.1.diff.gz"
LICENSE="GPL-2"
SLOT="0"
KEYWORDS="x86"
DEPEND="virtual/glibc"
S="${WORKDIR}/${PN}"

src_unpack() {
        unpack ${P//-/_}.orig.tar.gz
        cd $S
        gunzip -c ${DISTDIR}/${P//-/_}-6.1.diff.gz | patch -p1
}

src_compile() {
        ./autogen.sh \
                --prefix=/usr \
                --infodir=/usr/share/info \
                --mandir=/usr/share/man || die "./configure failed"
        emake || die
}

src_install () {
        #make DESTDIR=${D} install || die
        make \
                prefix=${D}/usr \
                mandir=${D}/usr/share/man \
                infodir=${D}/usr/share/info \
                install || die
}

