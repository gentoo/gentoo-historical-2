# Copyright 1999-2001 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License, v2 or later
# $Header: /var/cvsroot/gentoo-x86/kde-base/kdelibs/kdelibs-3.0.2.ebuild,v 1.4 2002/07/16 20:57:37 danarmak Exp $

inherit  kde kde.org
#don't inherit  kde-base or kde-dist! it calls need-kde which adds kdelibs to depend!

# check need for glib >=1.3.3 (we have 1.2.10 only; configure has no glib flag but searches for it)

DESCRIPTION="KDE ${PV} - Libraries"
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
	>=kde-base/arts-1.0.1
	app-text/ghostscript"

newdepend "/c"
newdepend "/autotools"

RDEPEND="$RDEPEND
	app-text/sgml-common
	cups? ( net-print/cups )
	dev-lang/python"

myconf="$myconf --enable-final --with-distribution=Gentoo"

qtver-from-kdever ${PV}
need-qt $selected_version

set-kdedir $PV

src_unpack() {

    base_src_unpack
    kde_sandbox_patch ${S}/kio/misc/kpac

}

src_compile() {

	kde_src_compile myconf

	use ipv6	|| myconf="$myconf --with-ipv6-lookup=no"
	use ssl		&& myconf="$myconf --with-ssl-dir=/usr"		|| myconf="$myconf --without-ssl"
	use alsa	&& myconf="$myconf --with-alsa"			|| myconf="$myconf --without-alsa"
	use cups	&& myconf="$myconf --enable-cups"		|| myconf="$myconf --disable-cups"
	
	[ "$ARCH" != "ppc" ] && \
		[ "$ARCH" != "sparc" ] && [ "$ARCH" != "sparc64" ] && \
		myconf="$myconf --enable-fast-malloc=full"
	
	kde_src_compile configure make

}

src_install() {
	
	kde_src_install
	
	dohtml *.html
	
	dodir /etc/env.d

	if [ "$KDE3DIR" != "$KDE3LIBSDIR" ]; then
echo "PATH=${KDE3LIBSDIR}/bin:${KDE3DIR}/bin
ROOTPATH=${KDE3LIBSDIR}/bin:${KDE3DIR}/bin
LDPATH=${KDE3LIBSDIR}/lib:${KDE3DIR}/lib" > ${D}/etc/env.d/65kdelibs-${PV}
	else
echo "PATH=${KDE3LIBSDIR}/bin
ROOTPATH=${KDE3LIBSDIR}/bin
LDPATH=${KDE3LIBSDIR}/lib" > ${D}/etc/env.d/65kdelibs-${PV}
	fi

	echo "KDEDIR=${KDE3DIR}" > ${D}/etc/env.d/50kdedir-${PV}
	
	dodir /usr/qt/3
	cd ${D}
	mv ./${KDEDIR}/lib/kde3/plugins ./usr/qt/3
	dosym /usr/qt/3/plugins /${KDEDIR}/lib/kde3/plugins

}


