# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/x11-libs/ecore/ecore-9999.ebuild,v 1.11 2005/12/14 04:21:43 joshuabaergen Exp $

inherit enlightenment

DESCRIPTION="core event abstraction layer and X abstraction layer (nice convenience library)"

IUSE="X directfb fbcon opengl ssl curl threads dbus"

RDEPEND=">=x11-libs/evas-0.9.9
	|| ( x11-libs/libXcursor virtual/x11 )
	ssl? ( dev-libs/openssl )
	curl? ( net-misc/curl )
	dbus? ( sys-apps/dbus )
	opengl? ( virtual/opengl )"
# Some extra deps that aren't necessary but will be used if they exist:
#		x11-libs/libXrandr
#		x11-libs/libXinerama
#		x11-libs/libXp

DEPEND="${RDEPEND}
	|| ( ( x11-proto/xproto
			x11-proto/xextproto
		)
		virtual/x11
	)"

src_compile() {
	export MY_ECONF="
		--enable-ecore-txt
		$(use_enable X ecore-x)
		--enable-ecore-job
		$(use_enable fbcon ecore-fb)
		$(use_enable directfb ecore-dfb)
		--enable-ecore-evas
		$(use_enable opengl ecore-evas-gl)
		$(use_enable X evas-xrender)
		$(use_enable directfb ecore-evas-dfb)
		$(use_enable fbcon ecore-evas-fb)
		--enable-ecore-evas-buffer
		--enable-ecore-con
		$(use_enable ssl openssl)
		--enable-ecore-ipc
		$(use_enable dbus ecore-dbus)
		--enable-ecore-config
		--enable-ecore-file
		$(use_enable curl)
		$(use_enable threads pthreads)
	"
	enlightenment_src_compile
}
