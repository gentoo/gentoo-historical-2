# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-gfx/fbida/fbida-2.05.ebuild,v 1.5 2007/04/22 14:38:30 spock Exp $

inherit eutils toolchain-funcs

DESCRIPTION="Image viewers for the framebuffer console (fbi) and X11 (ida)."
HOMEPAGE="http://linux.bytesex.org/fbida/"
SRC_URI="http://dl.bytesex.org/releases/${PN}/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~hppa ~ppc ~ppc64 ~sh ~sparc ~x86"
IUSE="png jpeg gif tiff curl lirc X fbcon pdf"

RDEPEND="jpeg? ( >=media-libs/jpeg-6b )
	png? ( media-libs/libpng )
	gif? ( media-libs/giflib )
	pdf? ( virtual/ghostscript media-libs/tiff )
	tiff? ( media-libs/tiff )
	curl? ( net-misc/curl )
	lirc? ( app-misc/lirc )
	X? ( || ( ( x11-libs/libX11 x11-libs/libXt x11-libs/libXpm )
			virtual/x11 )
		virtual/motif )
	!media-gfx/fbi
	media-libs/libexif
	>=media-libs/freetype-2.0
	>=media-libs/fontconfig-2.2
	media-fonts/ttf-bitstream-vera"

DEPEND="${RDEPEND}
	X? ( || ( ( x11-proto/xextproto x11-proto/xproto )
			virtual/x11 ) )"

src_unpack() {
	unpack ${A}
	cd ${S}
	sed -e 's/DGifOpenFileName,ungif/DGifOpenFileName,gif/' \
	    -e 's/-lungif/-lgif/' -i ${S}/GNUmakefile

	if [[ `gcc-major-version` -lt 4 ]]; then
		sed	-e 's/-Wno-pointer-sign//' -i ${S}/GNUmakefile
	fi

	# We don't want the binaries to be stripped automatically.
	sed -i -e 's/$(INSTALL) -s/$(INSTALL)/' ${S}/mk/Variables.mk

	epatch ${FILESDIR}/fbida-2.05-asmpage-fix.patch
}

src_compile() {
	# Let autoconf do its job and then fix things to build fbida
	# according to our specifications
	emake Make.config || die

	set_feat() {
		local useflag=${1}
		local config=${2}

		local option="yes"
		if ! use ${useflag}; then
			option="no"
		fi

		sed -e "s/${config}.*/${config} := ${option}/" -i ${S}/Make.config
	}

	set_feat fbcon 	HAVE_LINUX_FB_H
	set_feat X 		HAVE_MOTIF
	set_feat tiff 	HAVE_LIBTIFF

	# The 'pdf' flag forces the use of libtiff.
	set_feat pdf	HAVE_LIBTIFF
	set_feat png 	HAVE_LIBPNG
	set_feat gif 	HAVE_LIBUNGIF
	set_feat lirc 	HAVE_LIBLIRC
	set_feat curl 	HAVE_LIBCURL

	emake || die
}

src_install() {
	make \
		DESTDIR=${D} \
		prefix=/usr \
		install || die
	dodoc README

	if ! use pdf; then
		rm -f ${D}/usr/bin/fbgs ${D}/usr/share/man/man1/fbgs.1
	fi
}
