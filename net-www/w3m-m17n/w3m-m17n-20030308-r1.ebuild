# Copyright 1999-2003 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-www/w3m-m17n/w3m-m17n-20030308-r1.ebuild,v 1.2 2003/09/06 01:54:09 msterret Exp $

IUSE="gpm imlib ssl"

W3M_PV="0.4.1"
GC_PV="6.3alpha1"
MY_P=w3m-${W3M_PV}-m17n-${PV}

DESCRIPTION="Multilingual text based WWW browser"
SRC_URI="http://www2u.biglobe.ne.jp/~hsaka/w3m/patch/${MY_P}.tar.gz
	http://www.hpl.hp.com/personal/Hans_Boehm/gc/gc_source/gc${GC_PV}.tar.gz"
HOMEPAGE="http://www2u.biglobe.ne.jp/~hsaka/w3m/"

SLOT="0"
LICENSE="w3m"
KEYWORDS="~x86 ~alpha ~ppc ~sparc"

DEPEND=">=sys-libs/ncurses-5.2-r3
	>=sys-libs/zlib-1.1.3-r2
	dev-lang/perl
	imlib? ( >=media-libs/imlib-1.9.8
		media-libs/compface
		media-libs/libungif )
	gpm? ( >=sys-libs/gpm-1.19.3-r5 )
	ssl? ( >=dev-libs/openssl-0.9.6b )"

PROVIDE="virtual/textbrowser
	virtual/w3m"

S="${WORKDIR}/${MY_P}"

src_unpack() {
	unpack ${MY_P}.tar.gz
	cd ${S}

	# the boehm-gc which comes with w3m cannot be compiled on alpha
	rm -rf gc
	unpack gc${GC_PV}.tar.gz
	mv gc${GC_PV} gc
}

src_compile() {
	local myuse
	myuse="use_cookie=y use_ansi_color=y use_history=y \
		use_unicode=y charset=UTF-8"

	local myconf
	myconf="-prefix=/usr -mandir=/usr/share/man -sysconfdir=/etc/w3m \
		-suffix=-m17n -lang=en -model=custom -nonstop"

	if [ -n "`use ssl`" ] ; then
		myconf="${myconf} --ssl-includedir=/usr/include/openssl --ssl-libdir=/usr/lib"
		myuse="${myuse} use_ssl=y use_ssl_verify=y use_digest_auth=y"
	else
		myuse="${myuse} use_ssl=no"
	fi

	if [ -n "`use gpm`" ] ; then
		myuse="${myuse} use_mouse=y"
	else
		myuse="${myuse} use_mouse=n"
	fi

	if [ -n "`use imlib`" ] ; then
		myuse="${myuse} use_image=y use_w3mimg_x11=y use_w3mimg_fb=y w3mimgdisplay_setuid=n use_xface=y"
	else
		myuse="${myuse} use_image=n"
	fi

	env ${myuse} ./configure ${myconf} -cflags="${CFLAGS}" \
		|| die "configure failed"

	emake || die "make failed"
	perl -pi -e "s/'w3m'/'w3m-m17n'/" scripts/w3mman/w3mman
}

src_install() {
	einstall DESTDIR=${D}

	# w3mman and manpages conflict with those from w3m
	mv ${D}/usr/bin/w3mman{,-m17n}
	mv ${D}/usr/share/man/ja/man1/w3m{,-m17n}.1
	mv ${D}/usr/share/man/man1/w3m{,-m17n}.1
	mv ${D}/usr/share/man/man1/w3mman{,-m17n}.1

	if ! has_version 'net-www/w3m' ; then
		dosym /usr/bin/w3m{-m17n,}
		dosym /usr/bin/w3mman{-m17n,}
		dosym /usr/share/man/ja/man1/w3m{-m17n,}.1
		dosym /usr/share/man/man1/w3m{-m17n,}.1
		dosym /usr/share/man/man1/w3mman{-m17n,}.1
	fi

	dodoc doc/* README*
}
