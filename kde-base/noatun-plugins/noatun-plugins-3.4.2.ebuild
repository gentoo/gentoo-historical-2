# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/kde-base/noatun-plugins/noatun-plugins-3.4.2.ebuild,v 1.4 2005/08/08 20:50:53 kloeri Exp $
KMNAME=kdeaddons
MAXKDEVER=$PV
KM_DEPRANGE="$PV $MAXKDEVER"
inherit kde-meta

DESCRIPTION="Various plugins for noatun"
KEYWORDS="~alpha ~amd64 ~ppc ~ppc64 ~sparc ~x86"
IUSE="arts sdl berkdb"
DEPEND="$(deprange-dual $PV $MAXKDEVER kde-base/noatun)
	arts? ( $(deprange $PV $MAXKDEVER kde-base/arts) )
	sdl? ( >=media-libs/libsdl-1.2 )
	berkdb? ( || ( =sys-libs/db-4.3*
	               =sys-libs/db-4.2* ) )"

PATCHES="$FILESDIR/configure-fix-kdeaddons-db.patch
	$FILESDIR/configure-fix-kdeaddons-sdl.patch"

src_compile() {
	local myconf="$(use_with sdl)"

	if use berkdb; then
		if has_version "=sys-libs/db-4.3*"; then
			myconf="${myconf} --with-berkeley-db --with-db-lib=db_cxx-4.3
			        --with-extra-includes=/usr/include/db4.3"
		elif has_version "=sys-libs/db-4.2*"; then
			myconf="${myconf} --with-berkeley-db --with-db-lib=db_cxx-4.2
			        --with-extra-includes=/usr/include/db4.2"
		fi
	else
		myconf="${myconf} --without-berkeley-db"
	fi

	kde-meta_src_compile
}
