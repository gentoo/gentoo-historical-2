# Copyright 1999-2003 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-irc/bitchx/bitchx-1.0.19-r2.ebuild,v 1.12 2003/02/13 14:13:47 vapier Exp $

IUSE="ssl esd gnome xmms ncurses ipv6 gtk"

MY_P=ircii-pana-${PV/.0./.0c}
S=${WORKDIR}/BitchX
DESCRIPTION="An IRC Client"
SRC_URI="ftp://ftp.bitchx.com/pub/BitchX/source/${MY_P}.tar.gz"
HOMEPAGE="http://www.bitchx.com/"

SLOT="0"
LICENSE="GPL-2"
KEYWORDS="x86 ppc sparc "

inherit flag-o-matic
replace-flags -O[3-9] -O2

DEPEND=">=sys-libs/ncurses-5.1 
	ssl? ( >=dev-libs/openssl-0.9.6 )
	xmms? ( media-sound/xmms )
	gnome? ( >=gnome-base/gnome-libs-1.4.1.2-r1 )
	ncurses? ( sys-libs/ncurses )
	esd? ( >=media-sound/esound-0.2.5
		>=media-libs/audiofile-0.1.5 )
	gtk? ( =x11-libs/gtk+-1.2*
		>=media-libs/imlib-1.9.10-r1 )"

src_compile() {
	local myconf

	if [ "${DEBUG}" ]
	then
		einfo "debugging"
		myconf="${myconf} --enable-debug"
	fi

	use ssl \
		&& myconf="${myconf} --with-ssl" \
		|| myconf="${myconf} --without-ssl"

	use esd && use gtk \
		&& myconf="${myconf} --enable-sound" \
		|| myconf="${myconf} --disable-sound"
	
	use gtk \
	    || myconf="${myconf} --without-gtk"

	use ipv6 \
		&& myconf="${myconf} --enable-ipv6" \
		|| myconf="${myconf} --disable-ipv6"

	#not tested
#	use ncurses \
#		&& myconf="${myconf} --without-tgetent" \
#		|| myconf="${myconf} --with-tgetent"
	
	# lamer@gentoo.org BROKEN, will not work with our socks
	# implementations, is looking for a SOCKSConnect function that our
	# dante packages don't have :-(
	#use socks5 \
	#	&& myconf="${myconf} --with-socks=5" \
	#	|| myconf="${myconf} --without-socks"

	econf \
		--enable-cdrom \
		--with-plugins \
		${myconf} || die

	emake || die

}

src_install () {

	einstall || die

	rm ${D}/usr/share/man/man1/BitchX*
	doman doc/BitchX.1

	use gnome && ( \
		exeinto /usr/bin
		newexe ${S}/source/BitchX BitchX-1.0c19
		dosym gtkBitchX-1.0c19 /usr/bin/gtkBitchX
	)

	dosym BitchX-1.0c19 /usr/bin/BitchX

	chmod -x ${D}/usr/lib/bx/plugins/BitchX.hints

	cd ${S}
	dodoc Changelog README* IPv6-support COPYING
	cd doc
	insinto /usr/X11R6/include/bitmaps
	doins BitchX.xpm

	dodoc BitchX-* BitchX.bot *.doc BitchX.faq README.hooks 
	dodoc bugs *.txt functions ideas mode tcl-ideas watch
	dodoc *.tcl
	dohtml *.html

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
