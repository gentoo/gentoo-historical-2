# Copyright 1999-2002 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/kde-base/kdemultimedia/kdemultimedia-2.2.2-r1.ebuild,v 1.2 2003/02/01 20:07:51 jmorgan Exp $

IUSE="nas esd motif gtk slang alsa"
inherit kde-dist

SRC_URI="${SRC_URI}
	mirror://kde/security_patches/post-${PV}-${PN}.diff"

DESCRIPTION="KDE $PV - multimedia apps"
KEYWORDS="x86 sparc "
MAKEOPTS="${MAKEOPTS} -j1"
newdepend ">=sys-libs/ncurses-5.2
    >=media-sound/cdparanoia-3.9.8
    >=media-libs/libvorbis-1.0_beta4
	>=media-video/xanim-2.80.1
	alsa? ( >=media-libs/alsa-lib-0.5.9 )
	nas? ( >=media-libs/nas-1.4.1 )
	esd? ( >=media-sound/esound-0.2.22 )
	motif? ( >=x11-libs/openmotif-2.1.30 )
	gtk? ( =x11-libs/gtk+-1.2* )
	slang? ( >=sys-libs/slang-1.4.4 )"

src_unpack() {
	unpack ${P}.tar.bz2
	cd ${S}
	patch -p1 < ${DISTDIR}/post-${PV}-${PN}.diff
	patch -p0 < ${FILESDIR}/${P}-gentoo.diff
}

src_compile() {

	kde_src_compile myconf

	local myaudio
	local myinteface
	myaudio="--enable-audio=oss"
	myinterface="--enable-interface=xaw,ncurses"

	use alsa	&& myconf="$myconf --with-alsa" && myaudio="$myaudio,alsa"
	use nas		&& myaudio="$myaudio,nas"
	use esd		&& myaudio="$myaudio,esd"
	use motif	&& myinterface="$myinterface,motif"
	use gtk		&& myinterface="$myinterface,gtk"
	use slang	&& myinterface="$myinterface,slang"
# tcl tk does not work

	myconf="$myconf $myaudio $myinterface"

	kde_src_compile configure make

}


