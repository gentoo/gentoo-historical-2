# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/x11-misc/xlockmore/xlockmore-5.23.ebuild,v 1.1 2007/02/22 21:03:45 drac Exp $

inherit eutils pam flag-o-matic

IUSE="crypt debug nas esd motif opengl truetype gtk pam xlockrc unicode"

DESCRIPTION="Just another screensaver application for X"
SRC_URI="http://ftp.tux.org/pub/tux/bagleyd/${PN}/${P}.tar.bz2"
HOMEPAGE="http://www.tux.org/~bagleyd/xlockmore.html"

SLOT="0"
LICENSE="BSD GPL-2"
KEYWORDS="~amd64 ~hppa ~ppc ~ppc64 ~sparc ~x86"

RDEPEND="opengl? ( media-libs/mesa )
	x11-libs/libX11
	x11-libs/libXmu
	x11-libs/libXext
	x11-libs/libXt
	x11-libs/libXpm
	media-libs/freetype
	pam? ( virtual/pam )
	nas? ( media-libs/nas )
	esd? ( media-sound/esound )
	motif? ( x11-libs/openmotif )
	gtk? ( >=x11-libs/gtk+-2 )"
DEPEND="${RDEPEND}
	x11-proto/xineramaproto"

src_unpack() {
	unpack ${A}
	cd "${S}"

	# avoid prestripping
	sed -i -e 's:$stripprog:echo:g' install-sh
}

src_compile() {
	econf --enable-appdefaultdir=/usr/share/X11/app-defaults \
		--enable-vtlock \
		--without-ftgl \
		$(use_enable crypt) \
		$(use_enable opengl) \
		$(use_enable opengl gltt) \
		$(use_enable opengl mesa) \
		$(use_enable xlockrc xlockrc) \
		$(use_enable unicode use-mb) \
		$(use_enable pam) \
		$(use_with truetype ttf) \
		$(use_with gtk gtk2) \
		$(use_with motif) \
		$(use_with esd esound) \
		$(use_with nas) \
		$(use_with debug editres) \

	# fixes suid-with-lazy-bindings problem
	append-flags $(bindnow-flags)

	emake || die "emake failed."
}

src_install() {
	einstall xapploaddir="${D}"/usr/share/X11/app-defaults \
	|| die "einstall failed."

	# install pam.d file and unset setuid root
	pamd_mimic_system xlock auth
	use pam && chmod 755 "${D}"/usr/bin/xlock

	# ugly documentation hack to make it right
	mv xlock/xlock.man xlock.1
	doman xlock.1
	rm "${D}"/usr/share/man/xlock.1

	dohtml docs/*.html

	rm docs/*.html
	dodoc README docs/*
}
