# Copyright 1999-2003 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-www/w3m-m17n/w3m-m17n-0.4.2.ebuild,v 1.2 2003/10/04 22:21:45 usata Exp $

IUSE="X imlib imlib2 gtk xface migemo gpm ssl"
#IUSE="nls"

W3M_CVS_PV="1.862"
W3M_P="${P/-m17n/}+cvs-${W3M_CVS_PV}"

W3M_M17N_CVS_PV="1.859"
W3M_M17N_P="w3m-cvs-${W3M_M17N_CVS_PV}-m17n"
LIBWC_PV="20030224"

DESCRIPTION="Lightweight text based WWW browser w3m with multilingual extension"
HOMEPAGE="http://w3m.sourceforge.net/
	http://www2u.biglobe.ne.jp/~hsaka/w3m/
	http://www.page.sannet.ne.jp/knabe/w3m/w3m.html"
SRC_URI="http://dev.gentoo.org/~usata/distfiles/${W3M_P}.tar.gz
	http://www.page.sannet.ne.jp/knabe/w3m/${W3M_M17N_P}-1.diff.gz
	http://dev.gentoo.org/~usata/distfiles/libwc-${LIBWC_PV}.tar.gz"
#	nls? ( http://www.page.sannet.ne.jp/knabe/w3m/${W3M_M17N_P}-nls-1.diff.gz)

SLOT="0"
LICENSE="w3m"
KEYWORDS="~x86 ~alpha ~ppc ~sparc"

DEPEND="${RDEPEND}
	>=sys-apps/sed-4
	>=sys-devel/autoconf-2.57"
RDEPEND=">=sys-libs/ncurses-5.2-r3
	>=sys-libs/zlib-1.1.3-r2
	dev-lang/perl
	>=dev-libs/boehm-gc-6.2
	X? ( || ( !nopixbuf? ( >=media-libs/gdk-pixbuf-0.22.0 )
		imlib2? ( >=media-libs/imlib2-1.0.5 )
		imlib? ( >=media-libs/imlib-1.9.8 ) )
	)
	xface? ( media-libs/compface )
	gpm? ( >=sys-libs/gpm-1.19.3-r5 )
	migemo? ( >=app-text/migemo-0.40 )
	ssl? ( >=dev-libs/openssl-0.9.6b )"

PROVIDE="virtual/textbrowser
	virtual/w3m"

S="${WORKDIR}/${P/-m17n/}"

src_unpack() {

	unpack ${W3M_P}.tar.gz
	cd ${S}

	# libwc doesn't come with w3m-m17n now
	unpack libwc-${LIBWC_PV}.tar.gz

	unpack ${W3M_M17N_P}-1.diff.gz
	sed -i -e "/^--- w3m\/version.c.in/,+8d" ${W3M_M17N_P}-1.diff || die
	epatch ${W3M_M17N_P}-1.diff
	sed -i -e "s/0.4.2/0.4.2-m17n-20030308/" version.c.in || die

	epatch ${FILESDIR}/w3m-w3mman-gentoo.diff
	#use nls && epatch ${DISTDIR}/${W3M_M17N_P}-nls-1.diff.gz
	epatch ${FILESDIR}/${P}-imglib-gentoo.diff
}

src_compile() {

	local myconf migemo_command imglib

	if [ -n "`use X`" ] ; then
		myconf="${myconf} --enable-image=x11,fb `use_enable xface`"
		if [ ! -n "`use nopixbuf`" ] ; then
			imglib="gdk_pixbuf"
		elif [ -n "`use imlib2`" ] ; then
			imglib="imlib2"
		elif [ -n "`use imlib`" ] ; then
			imglib="imlib"
		else
			# defaults to gdk_pixbuf
			imglib="gdk_pixbuf"
		fi
	else
		myconf="${myconf} --enable-image=no"
	fi

	if [ -n "`use migemo`" ] ; then
		migemo_command="migemo -t egrep /usr/share/migemo/migemo-dict"
	else
		migemo_command="no"
	fi

	export WANT_AUTOCONF_2_5=1
	autoconf || die

	econf --program-suffix=-m17n \
		--enable-keymap=w3m \
		--with-editor=/usr/bin/nano \
		--with-mailer=/bin/mail \
		--with-browser=/usr/bin/mozilla \
		--with-termlib=ncurses \
		--with-imglib="${imglib}" \
		--with-migemo="${migemo_command}" \
		`use_enable gpm mouse` \
		`use_enable ssl digest-auth` \
		`use_with ssl` \
		${myconf} || die

	emake package=w3m-m17n W3M=w3m-m17n || die "make failed"
}

src_install() {

	make package=w3m-m17n DESTDIR=${D} install || die

	# w3mman and manpages conflict with those from w3m
	mv ${D}/usr/bin/w3mman{,-m17n}
	mv ${D}/usr/share/man/man1/w3mman{,-m17n}.1
	#mv ${D}/usr/share/man/man1/w3m{,-m17n}.1
	#mv ${D}/usr/share/man/ja/man1/w3m{,-m17n}.1

	if ! has_version 'net-www/w3m' ; then
		dosym /usr/bin/w3m{-m17n,}
		dosym /usr/bin/w3mman{-m17n,}
		dosym /usr/share/man/ja/man1/w3m{-m17n,}.1
		dosym /usr/share/man/man1/w3m{-m17n,}.1
		dosym /usr/share/man/man1/w3mman{-m17n,}.1
	fi

	insinto /usr/share/${PN}/Bonus
	doins Bonus/*
	dodoc README NEWS TODO ChangeLog
	docinto doc-en ; dodoc doc/*
	docinto doc-jp ; dodoc doc-jp/*
}
