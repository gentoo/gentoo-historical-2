# Copyright 1999-2002 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-p2p/gift-cvs/gift-cvs-0.10.0.ebuild,v 1.1 2002/11/29 12:22:28 verwilst Exp $

DESCRIPTION="Lets you connect to OpenFT, a decentralised p2p network like FastTrack"
HOMEPAGE="http://gift.sourceforge.net"
SLOT="0"
LICENSE="GPL-2"
KEYWORDS="x86 sparc sparc64"

DEPENDS="virtual/glibc
        >=sys-libs/zlib-1.1.4"

inherit cvs

ECVS_SERVER="cvs.gift.sourceforge.net:/cvsroot/gift"
ECVS_MODULE="giFT"
ECVS_TOP_DIR="${DISTDIR}/cvs-src/${PN}"
S=${WORKDIR}/${ECVS_MODULE}

src_compile() {

        cd ${S}
        ./autogen.sh --prefix=/usr --host=${CHOST} || die
        emake || die

}

src_install() {

        einstall giftconfdir=${D}/etc/giFT \
                 plugindir=${D}/usr/lib/giFT \
                 giftdatadir=${D}/usr/share/giFT \
                 giftperldir=${D}/usr/bin || die
        cd ${D}/usr/bin
        mv giFT-setup giFT-setup.orig
        sed 's:$prefix/etc/giFT/:/etc/giFT/:' giFT-setup.orig > giFT-setup
        chmod +x ${D}/usr/bin/giFT-setup

}

