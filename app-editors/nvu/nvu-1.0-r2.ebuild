# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-editors/nvu/nvu-1.0-r2.ebuild,v 1.5 2007/01/24 02:48:25 genone Exp $

inherit eutils mozconfig flag-o-matic multilib

DESCRIPTION="A WYSIWYG web editor for linux similiar to Dreamweaver"
HOMEPAGE="http://www.nvu.com/"
SRC_URI="http://cvs.nvu.com/download/${P}-sources.tar.bz2"
LICENSE="GPL-2"
SLOT="0"

KEYWORDS="~x86 ~ppc ~sparc ~amd64"
IUSE=""
DEPEND="|| ( x11-proto/printproto virtual/x11 )
	sys-apps/gawk
	dev-lang/perl
	>=media-libs/freetype-2.1.9-r1"

S=${WORKDIR}/mozilla

src_unpack() {
	unpack ${A}
	cd ${S}
	# Fix those darn directories!  Make something more "standard"
	# That can extend to future versions with much more ease. - Chris
	epatch ${FILESDIR}/1.0/nvu-0.50-dir.patch || die "failed to apply dir. patch"
	epatch ${FILESDIR}/1.0/nvu-0.50-freetype-compile.patch || die "failed to patch for freetype"
	epatch ${FILESDIR}/1.0/${P}-gcc4-1.patch || die "failed to apply gcc-4 patch"

	# I had to manually edit the mozconfig.linux file as it
	# has some quirks... just copy the darn thing over :) - Chris
	# cp ${FILESDIR}/mozconfig ${S}/.mozconfig
	# remove --enable-optimize and let the code below
	# add the appropriate one - basic
	# Also set mozilla-five-home (and libdir) below - herbs
	grep -v 'enable-optimize\|mozilla-five-home' \
		${FILESDIR}/1.0/mozconfig-1.0 > .mozconfig

	# Set the lib directory
	echo "ac_add_options --libdir=/usr/$(get_libdir)" >> .mozconfig
	echo "ac_add_options --with-default-mozilla-five-home=/usr/$(get_libdir)/nvu" >> .mozconfig

	# copied from mozilla.eclass (modified slightly),
	# otherwise it defaults to -O which crashes on startup for me - basic
	# Set optimization level based on CFLAGS
	if is-flag -O0; then
		echo 'ac_add_options --enable-optimize=-O0' >> .mozconfig
	elif is-flag -O1; then
		echo 'ac_add_options --enable-optimize=-O1' >> .mozconfig
	else
		# mozilla fallback
		echo 'ac_add_options --enable-optimize=-O2' >> .mozconfig
	fi
}

src_compile() {
	# The build system is a weeee bit sensitive to naughty -O flags.
	# filter them out and let the build system figure out what
	# won't let it die :) - Chris
	filter-flags '-O*'
	# epatch ${FILESDIR}/nvu-0.80-mozconfig.patch

	make -f client.mk build_all || die "Make failed"
}

src_install() {

	# patch the final nvu binary to workaround bug #67658
	epatch ${FILESDIR}/1.0/nvu-0.50-nvu.patch

	make -f client.mk DESTDIR=${D} install || die

	#menu entry for gnome/kde
	insinto /usr/share/applications
	sed -e "s:/usr/lib/nvu:/usr/$(get_libdir)/nvu:" \
		${FILESDIR}/1.0/nvu.desktop > ${T}/nvu.desktop
	doins ${T}/nvu.desktop
}

pkg_postinst() {
	elog "If you choose to setup the webbrowser feature to execute urls"
	elog "under the HELP section please refer to"
	elog "http://www.nvu.com/Building_From_Source.php#tipsandhints ."
	elog "Make sure you follow the instructions to the letter if you have"
	elog "any problems email me at anarchy@gentoo.org I will be more then"
	elog "happy to assist you. DO NOT file a bug report on this issue."
}
