# Copyright 1999-2001 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License, v2 or later
# Author Achim Gottinger <achim@gentoo.org>
# $Header: /var/cvsroot/gentoo-x86/net-irc/bitchx/bitchx-1.0.18-r5.ebuild,v 1.2 2002/04/07 10:58:39 gbevin Exp $

A=ircii-pana-1.0c18.tar.gz
S=${WORKDIR}/BitchX
DESCRIPTION="An IRC Client"
SRC_URI="ftp://ftp.bitchx.com/pub/BitchX/source/${A}"
HOMEPAGE="http://www.bitchx.com/"

DEPEND="virtual/glibc
        >=sys-libs/ncurses-5.1 
        ssl? ( >=dev-libs/openssl-0.9.6 )
	gnome? ( >=x11-libs/gtk+-1.2.10-r4
	         >=media-libs/imlib-1.9.10-r1
 	         >=gnome-base/gnome-libs-1.4.1.2-r1 )
	esd? ( >=media-sound/esound-0.2.5
	       >=media-libs/audiofile-0.1.5 )"

src_unpack() {
	unpack ${A}
	cd ${S}
	patch -p1 < ${FILESDIR}/${PF}-gentoo.diff || die
	patch -p1 < ${FILESDIR}/${P}-dupver.patch || die
}

src_compile() {
	local myopts

	if [ -n "`use ssl`" ]
	then
		myopts="$myopts --with-ssl"
	fi


	if [ -n "`use esd`" ]
	then
		myopts="$myopts --enable-sound"
	fi
	
	if [ -z "`use gnome`" ]
	then
	    myopts="$myopts --without-gtk"
	fi

	./configure --prefix=/usr --host=${CHOST} --build=${CHOST}	\
		    --enable-cdrom --enable-ipv6 --with-plugins 	\
		    ${myopts} || die
	emake || die

	if [ -n "`use gnome`" ]
	then
		myopts="$myopts --with-gtk"
		./configure --prefix=/usr --host=${CHOST} --build=${CHOST}	\
		    --enable-cdrom --enable-ipv6 --with-plugins 	\
		    ${myopts} || die
		emake || die
	fi

}

src_install () {
	make prefix=${D}/usr install || die
	cd ${D}/usr/bin

        if [ -n "`use gnome`" ]
	then
		exeinto /usr/bin
		newexe ${S}/source/BitchX BitchX-1.0c18
		dosym gtkBitchX-1.0c18 /usr/bin/gtkBitchX
	fi
	dosym BitchX-1.0c18 /usr/bin/BitchX

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
