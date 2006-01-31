# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-text/djvu/djvu-3.5.16.ebuild,v 1.2 2006/01/31 13:11:36 ehmsen Exp $

inherit nsplugins flag-o-matic fdo-mime eutils

MY_P="${PN}libre-${PV}"

DESCRIPTION="DjVu viewers, encoders and utilities."
HOMEPAGE="http://djvu.sourceforge.net"
SRC_URI="mirror://sourceforge/djvu/${MY_P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~x86 ~sparc ~amd64 ~ppc"
IUSE="xml qt jpeg tiff debug threads nls nsplugin kde"

DEPEND="jpeg? ( >=media-libs/jpeg-6b-r2 )
	tiff? ( media-libs/tiff )
	qt? ( <x11-libs/qt-4 )"

S=${WORKDIR}/${MY_P}

src_unpack() {
	unpack ${A}
	cd ${S}

	# gcc 4.1 compilation fixes
	epatch ${FILESDIR}/${P}-gcc41-hash.patch || die
	epatch ${FILESDIR}/${P}-gcc41.patch || die

	# Replace autochecking acdesktop.m4 with a gentoo-specific one
	cp ${FILESDIR}/gentoo-acdesktop.m4 ${S}/gui/desktop/acdesktop.m4

	aclocal -I config -I gui/desktop || die "aclocal failed"
	autoconf || die "autoconf failed"
	libtoolize --copy --force
}

src_compile() {
	# assembler problems and hence non-building with pentium4 
	# <obz@gentoo.org>
	replace-flags -march=pentium4 -march=pentium3

	if use kde ; then
		export kde_mimelnk=/usr/share/mimelnk
	fi

	# When enabling qt it must be compiled with threads. See bug #89544.
	if use qt ; then
		QTCONF=" --with-qt --enable-threads "
	elif use threads ; then
		QTCONF=" --enable-threads "
	else
		QTCONF=" --disable-threads "
	fi

	econf --enable-desktopfiles \
		$(use_enable xml xmltools) \
		$(use_with jpeg) \
		$(use_with tiff) \
		$(use_enable nls i18n) \
		$(use_enable debug) \
		${QTCONF} \
		|| die "econf failed"

	if ! use nsplugin; then
		sed -e 's:nsdjvu::' -i ${S}/gui/Makefile
	fi

	emake -j1 || die "emake failed"
}

src_install() {
	make DESTDIR=${D} plugindir=/usr/lib/${PLUGINS_DIR} install
}
