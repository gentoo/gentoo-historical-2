# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-misc/evidence/evidence-9999.ebuild,v 1.8 2005/09/16 00:17:48 vapier Exp $

ECVS_MODULE="evidence"
ECVS_SERVER="cvs.sourceforge.net:/cvsroot/evidence"
inherit enlightenment eutils flag-o-matic

DESCRIPTION="GTK2 file-manager"
HOMEPAGE="http://evidence.sourceforge.net/"

LICENSE="GPL-2"
IUSE="X debug gnome kde oggvorbis perl truetype xine avi mpeg"

DEPEND=">=dev-util/pkgconfig-0.5
	=x11-libs/gtk+-2*
	oggvorbis? ( media-libs/libvorbis
		media-libs/libogg )
	perl? ( dev-libs/libpcre )
	X? ( virtual/x11 )
	truetype? ( =media-libs/freetype-2* )
	kde? ( kde-base/kdelibs )
	xine? ( >=media-libs/xine-lib-1_rc1 )
	avi? ( >=media-video/avifile-0.7.38 )
	mpeg? ( media-libs/libmpeg3 )
	media-libs/libao
	virtual/libc
	sys-devel/gcc
	virtual/fam
	>=x11-libs/evas-0.9.9
	>=dev-db/edb-1.0.5
	>=dev-libs/eet-0.9.9
	>=x11-libs/ecore-0.9.9
	>=media-libs/imlib2-1.2.0
	gnome? ( >=gnome-base/gnome-vfs-2.0
		>=media-libs/libart_lgpl-2.0
		>=gnome-base/libgnomecanvas-2.0 )"

src_compile() {
	# if we turn this on evas gets turned off (bad !)
	#use gnome && MY_ECONF="${MY_ECONF} --enable-canvas-gnomecanvas"

#		$(use_enable gnome backend-gnomevfs2)
	export MY_ECONF="
		--enable-ecore-ipc
		--enable-canvas-evas2
		--enable-extra-themes
		--enable-extra-iconsets
		$(use_enable xine thumbnailer-xine)
		$(use_enable avi thumbnailer-avi)
		$(use_enable mpeg thumbnailer-mpeg3)
		$(use_enable perl pcre)
		$(use_enable X x)
		$(use_enable oggvorbis plugin-vorbis)
		$(use_enable truetype plugin-ttf)
		$(use_enable debug)
		$(use_with kde)
		"
	enlightenment_src_compile
}

src_install() {
	enlightenment_src_install

	# Fixup broken symlinks
	dosym efm /usr/share/evidence/icons/default
	dosym efm /usr/share/evidence/themes/default
	chown -R root:0 ${D}/usr/share/evidence

	dodoc docs/*
}
