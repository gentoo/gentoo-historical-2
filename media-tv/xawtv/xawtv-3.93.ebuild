# Copyright 1999-2004 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-tv/xawtv/xawtv-3.93.ebuild,v 1.1 2004/07/29 02:50:25 morfic Exp $

inherit virtualx

IUSE="aalib alsa lirc mmx motif nls opengl quicktime zvbi"

MY_PATCH="xaw-deinterlace-3.76-0.1.1.diff.bz2"
MY_FONT=tv-fonts-1.0
DESCRIPTION="TV application for the bttv driver"
HOMEPAGE="http://bytesex.org/xawtv/"
SRC_URI="http://dl.bytesex.org/releases/xawtv/${P}.tar.gz
	http://dl.bytesex.org/releases/tv-fonts/${MY_FONT}.tar.bz2
	mirror://gentoo/${MY_PATCH}"

SLOT="0"
LICENSE="GPL-2"
KEYWORDS="~x86 ~ppc ~sparc ~alpha ~ia64 ~amd64"

DEPEND=">=sys-libs/ncurses-5.1
	>=media-libs/jpeg-6b
	media-libs/libpng
	virtual/x11
	alsa? ( media-libs/alsa-lib )
	aalib? ( media-libs/aalib )
	motif? ( x11-libs/openmotif
		app-text/recode )
	opengl? ( virtual/opengl )
	quicktime? ( virtual/quicktime )
	zvbi? ( media-libs/zvbi )"

src_compile() {

#	mmx enables 32bit assembly which is not valid when compiling 64bit on amd64
	if [ "${ARCH}" = "x86" ]
	then
		myconf="`use_enable mmx`"
	else
		myconf=""
	fi

	econf \
		--with-x \
		--enable-xfree-ext \
		--enable-xvideo \
		--enable-dv \
		`use_enable motif` \
		`use_enable quicktime` \
		`use_enable alsa` \
		`use_enable lirc` \
		`use_enable opengl gl`\
		`use_enable zvbi`\
		${myconf} \
		`use_enable aalib aa` || die " xawtv configure failed"

	make || die

	cd ${WORKDIR}/${MY_FONT}
	DISPLAY="" Xmake || die "tvfonts failed"
}

src_install() {
	cd ${S}
	einstall \
		libdir=${D}/usr/lib/xawtv \
		resdir=${D}/etc/X11 || die

	dodoc COPYING Changes README* TODO

	if [ -d /var/www/localhost ]
	then
		exeinto /var/www/localhost/cgi-bin
		doexe scripts/webcam.cgi
		dodoc ${FILESDIR}/webcamrc
	fi

	if ! use nls
	then
		rm -f ${D}/usr/share/man/fr
		rm -f ${D}/usr/share/man/es
	fi

	# The makefile seems to be fubar'd for some data
	dodir /usr/share/${PN}
	mv ${D}/usr/share/*.list ${D}/usr/share/${PN}
	mv ${D}/usr/share/Index* ${D}/usr/share/${PN}

	cd ${WORKDIR}/${MY_FONT}
	insinto /usr/X11R6/lib/X11/fonts/xawtv
	doins *.gz fonts.alias
}

pkg_postinst() {

	ebegin "installing teletype fonts into /usr/X11R6/lib/X11/fonts/xawtv"
	cd /usr/X11R6/lib/X11/fonts/xawtv
	mkfontdir
	eend
}
