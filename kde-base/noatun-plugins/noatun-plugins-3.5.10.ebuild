# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/kde-base/noatun-plugins/noatun-plugins-3.5.10.ebuild,v 1.1 2008/09/14 00:00:34 carlo Exp $
KMNAME=kdeaddons
EAPI="1"
inherit db-use kde-meta

DESCRIPTION="Various plugins for Noatun."
KEYWORDS="~alpha ~amd64 ~hppa ~ia64 ~ppc ~ppc64 ~sparc ~x86 ~x86-fbsd"
IUSE="arts sdl berkdb"

DEPEND="|| ( >=kde-base/noatun-${PV}:${SLOT} >=kde-base/kdemultimedia-${PV}:${SLOT} )
	sdl? ( >=media-libs/libsdl-1.2 )
	berkdb? ( =sys-libs/db-4* )"

RDEPEND="${DEPEND}"

pkg_setup() {
	kde_pkg_setup
	if use sdl && ! built_with_use media-libs/libsdl X ; then
		eerror "media-libs/libsdl is not build with X support."
		die "Please reemerge media-libs/libsdl with USE=\"X\"."
	fi
}

src_compile() {
	local myconf="$(use_with sdl)"

	if use berkdb; then
		dblib="$(db_libname)"
		myconf="${myconf} --with-berkeley-db --with-db-lib=${dblib/-/_cxx-}
			--with-extra-includes=${ROOT}$(db_includedir)"
	else
		myconf="${myconf} --without-berkeley-db"
	fi

	kde-meta_src_compile
}
