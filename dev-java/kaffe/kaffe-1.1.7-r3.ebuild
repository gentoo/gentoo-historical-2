# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-java/kaffe/kaffe-1.1.7-r3.ebuild,v 1.4 2006/10/14 15:52:47 nichoj Exp $

JAVA_SUPPORTS_GENERATION_1="true"
inherit base eutils java-vm-2 flag-o-matic

DESCRIPTION="A cleanroom, open source Java VM and class libraries"
SRC_URI="ftp://ftp.kaffe.org/pub/${PN}/v1.1.x-development/${P}.tar.gz"
HOMEPAGE="http://www.kaffe.org/"

#robilad recommended in bug 103978 that we leave the X and QT
#awt backends disabled for now. Please check the status of these
#backends with new upstream versions.
#	X?( virtual/x11 )
#	qt?( =x11-libs/qt-3.3* )

DEPEND="
	>=media-libs/jpeg-6b
	>=media-libs/libpng-1.2.1
	app-arch/zip
	dev-java/jikes
	dev-libs/libxml2
	sys-libs/zlib
	gtk? (
		>=dev-libs/glib-2.0
		>=x11-libs/gtk+-2.0
		>=media-libs/libart_lgpl-2.0 )
	esd? ( >=media-sound/esound-0.2.1 )
	alsa? ( >=media-libs/alsa-lib-1.0.1 )
	gmp? ( >=dev-libs/gmp-3.1 )"
RDEPEND=${DEPEND}

# We need to build this after kaffe because it is implemented in java
PDEPEND="dev-java/gjdoc"
LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ~ppc x86"
#X qt
IUSE="alsa esd gmp gtk nls"

# kaffe-1.1.6-alsa.patch is needed to prevent compile errors with newer alsas
#	(see bug #119272)
#PATCHES="${FILESDIR}/${PN}-1.1.6-alsa.patch"

# ignore execstack for now. needs to be fixed upstream
# http://kaffe.org/cgi-bin/bugzilla/show_bug.cgi?id=59
QA_EXECSTACK_x86="opt/${P}/jre/lib/i386/libkaffevm-1.1.7.so"

pkg_setup() {
	if ! use gmp; then
		ewarn "You have don't have the gmp use flag set."
		ewarn "Using gmp is the default upstream setting."
		epause 3
	fi

	if ! use gtk; then
		ewarn ""
		ewarn "The gtk use flag is needed for a awt implementation."
		ewarn "Don't file bugs for awt not working when you have"
		ewarn "gtk use flag turned off."
		epause 3
	fi
}

src_compile() {
	local confargs=""

	# see #88330
	filter-flags "-fomit-frame-pointer"
	append-flags "-fno-strict-aliasing"

	if ! use alsa && ! use esd; then
		confargs="${confargs} --disable-sound"
	fi

	! use gmp && confargs="${confargs} --enable-pure-java-math"

#		$(use_with X x) \
#		$(use_with X kaffe-x-awt) \
#		$(use_with qt kaffe-qt-awt ) \

	# according to dalibor, this is needed on ppc because jit is
	# not complete
	# TODO needs testing!
	use ppc && confargs="${confargs} --with-engine=intrp"

	# Use bundled fastjar until we have a separate fastjar package
	# bug #141477
	FASTJAR="$S/external/gcc/fastjar/fastjar"
	# --with-rt-jar in 1.1.7 to use the system installed classpath
	econf \
		--disable-dependency-tracking \
		--prefix=/opt/${P} \
		--host=${CHOST} \
		$(use_with alsa)\
		$(use_with esd) \
		$(use_with gmp) \
		$(use_enable nls) \
		$(use_enable gtk gtk-peer) \
		${confargs} \
		--with-jikes \
		--disable-gjdoc || die "Failed to configure."

	# --with-bcel
	# --with-profiling
	emake || die "Failed to compile"
}

src_install() {
	emake DESTDIR="${D}" install || die "Failed to install"
	set_java_env

	# use doexe to ensure executable bit (bug #144635)
	echo '#!/bin/bash' > javadoc
	echo 'exec /usr/bin/gjdoc "${@}"' >> javadoc
	exeinto "/opt/${P}/bin/"
	doexe javadoc

	# Remove some files that collide with classpath
	rm ${D}/usr/share/info/vmintegration.info \
		${D}/usr/share/info/hacking.info

	# Add symlink to glibj.zip, for bug #148607
	cd ${D}/opt/${P}/jre/lib
	ln -s glibj.zip rt.jar
}

pkg_postinst() {
	ewarn "Please, do not use Kaffe as your default JDK/JRE!"
	ewarn "Kaffe is currently meant for testing... it should be"
	ewarn "only be used by developers or bug-hunters willing to deal"
	ewarn "with oddities that are bound to come up while using Kaffe!"
}
