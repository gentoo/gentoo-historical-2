# Copyright 2002 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-im/ymessenger/ymessenger-0.99.19.ebuild,v 1.12 2003/01/18 23:02:19 raker Exp $

IUSE=""

# If you are looking in here, it is because emerge has instructed you to do
# so.  Please go to http://messenger.yahoo.com/download/unix.html and scroll
# all the way to the bottom.  There, please click on the tar.gz file for
# Debian Sid, and download that file to /usr/portage/distfiles.

MY_P=${PN}_${PV}-1
S=${WORKDIR}/opt/${PN}
DESCRIPTION="Yahoo's instant messenger client"
SRC_URI=""
HOMEPAGE="http://messenger.yahoo.com/messenger/download/unix.html"

DEPEND="media-libs/gdk-pixbuf
	gnome-extra/gtkhtml"
RDEPEND="virtual/x11"

RESTRICT="fetch"

SLOT="0"
LICENSE="yahoo"
KEYWORDS="x86 -ppc -sparc "

pkg_setup() {
	if [ ${ARCH} != "x86" ] ; then
		einfo "This is an x86 only package, sorry"
		die "Not supported on your ARCH"
	fi
}

src_unpack() {
	if [ ! -f ${DISTDIR}/${MY_P}.tar.gz ]
	then
		die "Please download ${MY_P} from ${HOMEPAGE}.  Scroll to the bottom to find the tarballs for Non-Root Installs.-- Note that you need the one for Debian Sid -- and place into ${DISTDIR}"
	fi
	unpack ${MY_P}.tar.gz || die
}

src_compile() {
	cd bin
	cp yahoo_gnome.png yahoo.png
	cp yahoo_kde.xpm yahoo.xpm

	#use kde && ( \
	#	mv ymessenger.kdelnk ymessenger.kdelnk.old
	#	sed "s:^Ic.*:Icon=${KDEDIR}/share/icons/hicolor/48x48/apps/yahoo.png:" \
	#		ymessenger.kdelnk.old > ymessenger.kdelnk
	#)
	
	#use gnome && ( \
	#	mv ymessenger.desktop ymessenger.desktop.old
	#	sed "s:Icon.*:Icon=/usr/share/pixmaps/yahoo.xpm:" \
	#		ymessenger.desktop.old > ymessenger.desktop
	#)
}

src_install () {

	insinto /opt/ymessenger/bin
	doins bin/*

	exeinto /opt/ymessenger/bin
	#doexe bin/ymessenger
	doexe bin/ymessenger.bin
	rm ${D}/opt/ymessenger/bin/ymessenger
	dosym /opt/ymessenger/bin/ymessenger.bin /opt/ymessenger/bin/ymessenger

	#cp -a lib ${D}/opt/${PN}
	
	#use gnome && ( \
	#	insinto /usr/share/gnome/apps/Internet
	#	doins ymessenger.desktop
	#
	#	insinto /usr/share/pixmaps
	#	doins yahoo.xpm
	#) || (
	#	dohtml yahoo.xpm
	#)
	
	#use kde && ( \
	#	insinto ${KDEDIR}/share/applnk/Applications
	#	doins ymessenger.kdelnk
	#
	#	insinto ${KDEDIR}/share/icons/hicolor/48x48/apps
	#	doins yahoo.png
	#) || (
	#	dohtml yahoo.png
	#)

	dodir /etc/env.d
	echo "PATH=/opt/ymessenger/bin" > ${D}/etc/env.d/97ymessenger
}

pkg_postinst() {
	einfo ""
	einfo "If you are upgrading from an older version of ymessenger,"
	einfo "please unmerge the previous version."
	einfo "-=AND=-"
	einfo "mv ~/.ymessenger/preferences ~/.ymessenger/preferences.old"
	einfo ""
}
