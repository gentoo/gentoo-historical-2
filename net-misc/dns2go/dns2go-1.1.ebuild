# Copyright 1999-2001 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License, v2 or later
# Author Bart Verwilst <bart.verwilst@pandora.be>
# dns2go-1.1.ebuild, v 1.0 2001/09/27 18:53

A="d2gsetup(linux).tar.gz"
S=${WORKDIR}/dns2go-1.1-1
DESCRIPTION="Dns2Go Linux Client v1.1"
SRC_URI="ftp://ftp2.deerfield.com/pub/dns2go/linux/${A}"
HOMEPAGE="http://www.dns2go.com"

DEPEND="virtual/glibc"

src_install() {
    dobin dns2go
    doman dns2go.1 dns2go.conf.5
    dodoc INSTALL README LICENSE
}


