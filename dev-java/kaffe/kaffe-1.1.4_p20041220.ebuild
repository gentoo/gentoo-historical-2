# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-java/kaffe/kaffe-1.1.4_p20041220.ebuild,v 1.6 2005/09/10 16:48:52 betelgeuse Exp $

inherit java flag-o-matic

date=${PV/*_p/}
DESCRIPTION="A cleanroom, open source Java VM and class libraries"
SRC_URI="http://dev.gentoo.org/~karltk/projects/java/distfiles/kaffe-${date}-gentoo.tar.gz"
HOMEPAGE="http://www.kaffe.org/"
DEPEND=">=dev-libs/gmp-3.1
	>=media-libs/jpeg-6b
	>=media-libs/libpng-1.2.1
	virtual/libc
	virtual/x11
	>=dev-java/java-config-0.2.4
	dev-java/jikes
	app-arch/zip
	>=dev-java/java-config-0.2.4
	alsa? ( >=media-libs/alsa-lib-1.0.1 )
	esd?  ( >=media-sound/esound-0.2.1 )"
RDEPEND=${DEPEND}

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~x86"
IUSE="alsa esd"

PROVIDE="virtual/jdk
	virtual/jre"
S=${WORKDIR}/kaffe-${date}

src_compile() {
	# see #88330
	strip-flags "-fomit-frame-pointer"

	./configure \
		--prefix=/opt/${P} \
		--host=${CHOST} \
		`use_enable alsa`\
		`use_enable esd` \
		--with-jikes || die "Failed to configure"
	# --with-bcel
	# --with-profiling
	make || die "Failed to compile"
}

src_install() {
	make DESTDIR=${D} install || die "Failed to install"
	set_java_env ${FILESDIR}/${VMHANDLE} || die "Failed to install environment files"
}

pkg_postinst() {
	ewarn "By all means, do not use Kaffe as your default JDK/JRE!"
	ewarn "Kaffe is currently meant for testing... it should be"
	ewarn "only be used by developers or bug-hunters willing to deal"
	ewarn "with oddities that are bound to come up while using Kaffe!"
}
