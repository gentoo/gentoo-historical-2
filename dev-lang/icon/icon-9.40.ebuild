# Copyright 1999-2001 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License, v2 or later
# Author Dan Armak <danarmak@gentoo.org>
# $Header: /var/cvsroot/gentoo-x86/dev-lang/icon/icon-9.40.ebuild,v 1.1 2001/07/31 22:51:49 danarmak Exp $

S=${WORKDIR}/icon.v940src
SRC_URI="http://www.cs.arisona.edu/icon/ftp/packages/unix/icon.v940src.tgz"

HOMEPAGE="http://www.cs.arisona.edu/icon/"
DESCRIPTION="icon is a v. high level language"

DEPEND="X? ( virtual/x11 )
	sys-devel/gcc"

src_unpack() {
    
    cd ${WORKDIR}
    unpack ${A}
    cd ${S}/config/unix/intel_linux
    patch -p0 <${FILESDIR}/${P}-gentoo.diff
    
}

src_compile() {
    
    cd ${S}

    if [ "`use X`" ]; then
        try make X-Configure name=intel_linux
    else
	try make Configure name=intel_linux
    fi
    
    try make
    
    # small builtin test
    try make Samples
    # large builtin test
    try make Test

}

src_install () {
    
    #try make Install dest=${D}/opt/icon
    # fhs-problems, manual rectify
    
    into /usr
    
    cd ${S}/bin
    rm .placeholder libXpm.a rt.h
    dobin *
    
    cd ${S}/lib
    rm .placeholder
    dolib *
    
    cd ${S}/man/man1
    doman icont.1
    
    cd ${S}/doc
    dodoc * ../README
    
}
