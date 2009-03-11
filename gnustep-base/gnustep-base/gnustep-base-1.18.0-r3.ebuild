# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/gnustep-base/gnustep-base/gnustep-base-1.18.0-r3.ebuild,v 1.1 2009/03/11 14:15:53 voyageur Exp $

EAPI=2

inherit autotools gnustep-base

DESCRIPTION="A library of general-purpose, non-graphical Objective C objects."

HOMEPAGE="http://www.gnustep.org"
SRC_URI="ftp://ftp.gnustep.org/pub/gnustep/core/${P}.tar.gz"
KEYWORDS="~alpha ~amd64 ~ppc ~sparc ~x86 ~x86-fbsd"
SLOT="0"
LICENSE="GPL-2 LGPL-2.1"

IUSE="gcc-libffi gnutls zeroconf"

DEPEND="${GNUSTEP_CORE_DEPEND}
	>=gnustep-base/gnustep-make-2.0
	!gcc-libffi? ( dev-libs/ffcall
		gnustep-base/gnustep-make[-native-exceptions] )
	gcc-libffi? ( >=sys-devel/gcc-3.3.5[libffi] )
	gnutls? ( net-libs/gnutls )
	>=dev-libs/libxml2-2.6
	>=dev-libs/libxslt-1.1
	>=dev-libs/gmp-4.1
	>=dev-libs/openssl-0.9.7
	>=sys-libs/zlib-1.2
	zeroconf? ( || (
		net-dns/avahi[mdnsresponder-compat]
		net-misc/mDNSResponder ) )"
RDEPEND="${DEPEND}"

src_prepare() {
	# Automagic dependency on mdns-responder
	epatch "${FILESDIR}"/${P}-mdns_configure.patch

	eautoreconf
}

src_configure() {
	egnustep_env

	local myconf
	if use gcc-libffi;
	then
		myconf="--enable-libffi --disable-ffcall"
	else
		myconf="--disable-libffi --enable-ffcall"
	fi

	myconf="$myconf $(use_enable gnutls tls)"
	myconf="$myconf $(use_enable zeroconf)"
	myconf="$myconf --with-xml-prefix=/usr"
	myconf="$myconf --with-gmp-include=/usr/include --with-gmp-library=/usr/lib"
	myconf="$myconf --with-default-config=/etc/GNUstep/GNUstep.conf"

	econf $myconf || die "configure failed"
}

src_install() {
	# We need to set LD_LIBRARY_PATH because the doc generation program
	# uses the gnustep-base libraries.  Since egnustep_env "cleans the
	# environment" including our LD_LIBRARY_PATH, we're left no choice
	# but doing it like this.

	egnustep_env
	egnustep_install

	if use doc ; then
		export LD_LIBRARY_PATH="${S}/Source/obj:${LD_LIBRARY_PATH}"
		egnustep_doc
	fi
	egnustep_install_config

	dodir /etc/revdep-rebuild
	sed -e 's|$GNUSTEP_SEARCH_DIRS|'"$GNUSTEP_SYSTEM_LIBRARIES $GNUSTEP_SYSTEM_TOOLS $GNUSTEP_LOCAL_LIBRARIES $GNUSTEP_LOCAL_TOOLS"'|' \
		"${FILESDIR}"/50-gnustep-revdep \
		> "${D}/etc/revdep-rebuild/50-gnustep-revdep"
}

pkg_postinst() {
	ewarn "The shared library version has changed in this release."
	ewarn "You will need to recompile all Applications/Tools/etc in order"
	ewarn "to use this library."
	ewarn "Run:"
	ewarn "revdep-rebuild --library \"libgnustep-base.so.1.1[0-6]\""
}
