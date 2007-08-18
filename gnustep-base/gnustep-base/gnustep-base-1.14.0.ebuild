# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/gnustep-base/gnustep-base/gnustep-base-1.14.0.ebuild,v 1.1 2007/08/18 14:21:59 grobian Exp $

inherit gnustep-base

DESCRIPTION="A library of general-purpose, non-graphical Objective C objects."

HOMEPAGE="http://www.gnustep.org"
SRC_URI="ftp://ftp.gnustep.org/pub/gnustep/core/${P}.tar.gz"
KEYWORDS="~amd64 ~x86"
SLOT="0"
LICENSE="GPL-2 LGPL-2.1"

IUSE="gcc-libffi"

DEPEND="${GNUSTEP_CORE_DEPEND}
	>=gnustep-base/gnustep-make-2.0
	!gcc-libffi? ( dev-libs/ffcall )
	gcc-libffi? ( >=sys-devel/gcc-3.3.5 )
	>=dev-libs/libxml2-2.6
	>=dev-libs/libxslt-1.1
	>=dev-libs/gmp-4.1
	>=dev-libs/openssl-0.9.7
	>=sys-libs/zlib-1.2"
RDEPEND="${DEPEND}"

src_compile() {
	egnustep_env

	local myconf
	if use gcc-libffi;
	then
		myconf="--enable-libffi --disable-ffcall"
		myconf="${myconf} --with-ffi-library=$(gcc-config -L) --with-ffi-include=$(gcc-config -L | sed 's/:.*//')/include/libffi"
	else
		myconf="--disable-libffi --enable-ffcall"
	fi

	myconf="$myconf --with-xml-prefix=/usr"
	myconf="$myconf --with-gmp-include=/usr/include --with-gmp-library=/usr/lib"
	myconf="$myconf --with-default-config=/etc/GNUstep/GNUstep.conf"

	econf $myconf || die "configure failed"

	egnustep_make
}

src_install() {
	gnustep-base_src_install

	dodir /etc/revdep-rebuild
	sed -e 's|$GNUSTEP_SEARCH_DIRS|'"$GNUSTEP_SYSTEM_ROOT $GNUSTEP_LOCAL_ROOT"'|' \
		"${FILESDIR}"/50-gnustep-revdep \
		> "${D}/etc/revdep-rebuild/50-gnustep-revdep"
}

pkg_postinst() {
	ewarn "The shared library version has changed in this release."
	ewarn "You will need to recompile all Applications/Tools/etc in order"
	ewarn "to use this library."
	ewarn "Run:"
	ewarn "revdep-rebuild --library \"libgnustep-base.so.1.1[0-3]\""
}
