# Copyright 1999-2002 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2 
# $Header: /var/cvsroot/gentoo-x86/media-video/xawtv/xawtv-3.80.ebuild,v 1.1 2002/12/13 05:23:21 seemant Exp $

IUSE="aalib motif alsa opengl nls"

S=${WORKDIR}/${P}
MY_FONT=tv-fonts-1.0
DESCRIPTION="TV application for the bttv driver"
SRC_URI="http://bytesex.org/xawtv/${PN}_${PV}.tar.gz
	http://bytesex.org/xawtv/${MY_FONT}.tar.bz2
	mirror://sourceforge/xaw-deinterlace/xaw-deinterlace-3.76-0.1.0.diff"
HOMEPAGE="http://bytesex.org/xawtv/"

SLOT="0"
LICENSE="GPL-2"
KEYWORDS="x86"

DEPEND=">=sys-libs/ncurses-5.1
	>=media-libs/jpeg-6b
	>=media-libs/libpng-1.0.8
	media-libs/zvbi
	virtual/x11
	alsa? ( media-libs/alsa-lib )
	aalib? ( media-libs/aalib )
	motif? ( x11-libs/openmotif )
	opengl? ( virtual/opengl )
	quicktime? ( media-libs/libquicktime )"

src_unpack() {
	unpack ${PN}_${PV}.tar.gz
	cd ${S}
	patch -p1 < ${DISTDIR}/xaw-deinterlace-3.76-0.1.0.diff || die

	unpack ${MY_FONT}.tar.bz2
	cd ${S}/${MY_FONT}
	patch -p0 < ${FILESDIR}/${MY_FONT}-gentoo.diff || die
}

src_compile() {
	local myconf
	use motif \
		&& myconf="--enable-motif" \
		|| myconf="--disable-motif"

	use aalib \
		&& myconf="${myconf} --enable-aa" \
		|| myconf="${myconf} --disable-aa"

	use quicktime \
		&& myconf="${myconf} --enable-quicktime" \
		|| myconf="${myconf} --disable-quicktime"

	use alsa \
		&& myconf="${myconf} --enable-alsa" \
		|| myconf="${myconf} --disable-alsa"


	use opengl \
		&& myconf="${myconf} --enable-gl" \
		|| myconf="${myconf} --disable-gl"

	econf \
		--with-x \
		--enable-xfree-ext \
		--enable-xvideo \
		--enable-zvbi \
		${myconf} || die

	emake || die

	cd ${MY_FONT}
	make || die
}

src_install() {
	cd ${S}
	einstall \
		resdir=${D}/etc/X11 || die

	dodoc COPYING Changes README* TODO

	exeinto /home/httpd/cgi-bin
	doexe scripts/webcam.cgi
	dodoc ${FILESDIR}/webcamrc

	if [ -z "`use nls`" ]
	then
		rm -f ${D}/usr/share/man/fr
		rm -f ${D}/usr/share/man/es
	fi

	# The makefile seems to be fubar'd for some data
	dodir /usr/share/${PN}
	mv ${D}/usr/share/*.list ${D}/usr/share/${PN}
	mv ${D}/usr/share/Index* ${D}/usr/share/${PN}

	cd ${MY_FONT}
	insinto /usr/X11R6/lib/X11/fonts/xawtv
	doins *.gz fonts.alias
}

pkg_postinst() {

	ebegin "installing teletype fonts into /usr/X11R6/lib/X11/fonts/xawtv"
	cd /usr/X11R6/lib/X11/fonts/xawtv
	mkfontdir
	eend
}
