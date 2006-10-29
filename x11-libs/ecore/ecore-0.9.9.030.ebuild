# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/x11-libs/ecore/ecore-0.9.9.030.ebuild,v 1.2 2006/10/29 03:27:50 vapier Exp $

inherit enlightenment

DESCRIPTION="core event abstraction layer and X abstraction layer (nice convenience library)"

IUSE="X directfb fbcon opengl ssl curl threads dbus"

RDEPEND=">=x11-libs/evas-0.9.9
	X? ( x11-libs/libXcursor )
	ssl? ( dev-libs/openssl )
	curl? ( net-misc/curl )
	dbus? ( sys-apps/dbus )
	opengl? ( virtual/opengl )"

DEPEND="${RDEPEND}
	X? ( x11-proto/xproto x11-proto/xextproto )"

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
