# Copyright 1999-2002 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/kde-base/kdelibs/kdelibs-3.0.4.ebuild,v 1.5 2002/10/27 11:16:57 danarmak Exp $
inherit kde kde.org
#don't inherit  kde-base or kde-dist! it calls need-kde which adds kdelibs to depend!

# check need for glib >=1.3.3 (we have 1.2.10 only; configure has no glib flag but searches for it)

# Only here, override kde.org's SRC_URI because of the unique 3.0.3a version number
SRC_URI="mirror://kde/stable/3.0.4/src/$P.tar.bz2"

DESCRIPTION="KDE $PV - base libraries needed by all kde programs"
KEYWORDS="x86 ppc alpha"
HOMEPAGE="http//www.kde.org/"

SLOT="3.0"
LICENSE="GPL-2 LGPL-2"

# kde.eclass has kdelibs in DEPEND, and we can't have that in here. so we recreate the entire
# DEPEND from scratch.
DEPEND=""
RDEPEND=""
newdepend "sys-devel/perl
	>=media-libs/audiofile-0.1.9
	>=sys-apps/bzip2-1.0.1
	>=dev-libs/libxslt-1.0.7
	>=dev-libs/libpcre-3.5
	>=dev-libs/libxml2-2.4.10
	ssl? ( >=dev-libs/openssl-0.9.6 )
	alsa? ( >=media-libs/alsa-lib-0.5.9 )
	cups? ( >=net-print/cups-1.1.14 )
	>=media-libs/tiff-3.5.5
	app-admin/fam-oss
	~kde-base/arts-1.0.4
	app-text/ghostscript"

newdepend "/c"
newdepend "/autotools"

RDEPEND="$RDEPEND
	app-text/sgml-common
	cups? ( net-print/cups )
	dev-lang/python
	>=sys-apps/portage-2.0.36" # for bug #7359

set_enable_final
myconf="$myconf --with-distribution=Gentoo"
use ipv6	|| myconf="$myconf --with-ipv6-lookup=no"
use ssl		&& myconf="$myconf --with-ssl-dir=/usr"		|| myconf="$myconf --without-ssl"
use alsa	&& myconf="$myconf --with-alsa"			|| myconf="$myconf --without-alsa"
use cups	&& myconf="$myconf --enable-cups"		|| myconf="$myconf --disable-cups"

[ "$ARCH" != "ppc" ] && \
    [ "$ARCH" != "sparc" ] && [ "$ARCH" != "sparc64" ] && \
	[ "$ARCH" != "alpha" ] && \
    myconf="$myconf --enable-fast-malloc=full"

qtver-from-kdever ${PV}
need-qt $selected_version

set-kdedir $PV

src_unpack() {

    base_src_unpack
    kde_sandbox_patch ${S}/kio/misc/kpac

}


src_install() {
	
	kde_src_install
	
	dohtml *.html
	
	dodir /etc/env.d

	echo "PATH=${PREFIX}/bin
ROOTPATH=${PREFIX}/bin
LDPATH=${PREFIX}/lib
KDEDIRS=$PREFIX
CONFIG_PROTECT=${PREFIX}/share/config" > ${D}/etc/env.d/65kdelibs-${PV} # number goes down with version upgrade

	echo "KDEDIR=$PREFIX" > ${D}/etc/env.d/50kdedir-${PV} # number goes up with version upgrade
	
}


