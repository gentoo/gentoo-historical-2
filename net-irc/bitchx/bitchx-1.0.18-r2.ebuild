# Copyright 1999-2001 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License, v2 or later
# Author Achim Gottinger <achim@gentoo.org>
# $Header: /var/cvsroot/gentoo-x86/net-irc/bitchx/bitchx-1.0.18-r2.ebuild,v 1.5 2001/08/08 03:48:34 chadh Exp $

A=ircii-pana-1.0c18.tar.gz
S=${WORKDIR}/BitchX
DESCRIPTION="An IRC Client"
SRC_URI="ftp://ftp.bitchx.com/pub/BitchX/source/${A}"
HOMEPAGE="http://www.bitchx.com/"

DEPEND="virtual/glibc >=sys-libs/ncurses-5.1 ssl? ( >=dev-libs/openssl-0.9.6 )"

src_unpack() {
  unpack ${A}
  cd ${S}
  patch -p1 < ${FILESDIR}/${PF}-gentoo.diff
}

src_compile() {
    local myopts
    if [ -n "`use ssl`" ]
    then
	myopts="$myopts --with-ssl"
    fi
    try ./configure --prefix=/usr --without-gtk --without-esd ${myopts} --host=${CHOST} --build=${CHOST}\
	--enable-cdrom --enable-ipv6 --with-plugins --disable-sound 
    try make
}

src_install () {

	try make prefix=${D}/usr install
	cd ${D}/usr/bin
	rm -f gtkBitchX
	rm -f BitchX
	dosym /usr/bin/BitchX-1.0c18 /usr/bin/BitchX
	chmod -x ${D}/usr/lib/bx/plugins/BitchX.hints

    cd ${S}
    dodoc Changelog README* IPv6-support
    cd doc
    insinto /usr/X11R6/include/bitmaps
    doins BitchX.xpm

    dodoc BitchX-* BitchX.bot *.doc BitchX.faq README.hooks 
    dodoc bugs *.txt functions ideas mode tcl-ideas watch
    dodoc *.tcl
    docinto html
    dodoc *.html

    docinto plugins
    dodoc plugins
    cd ../dll
    insinto /usr/lib/bx/wav
    doins wavplay/*.wav
    cp acro/README acro/README.acro
    dodoc acro/README.acro
    cp arcfour/README arcfour/README.arcfour
    dodoc arcfour/README.arcfour
    cp blowfish/README blowfish/README.blowfish
    dodoc blowfish/README.blowfish
    dodoc nap/README.nap
    cp qbx/README qbx/README.qbx
    dodoc qbx/README.qbx
}
