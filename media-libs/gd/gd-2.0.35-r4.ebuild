# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-libs/gd/gd-2.0.35-r4.ebuild,v 1.2 2014/06/15 00:59:17 vapier Exp $

EAPI="5"

inherit autotools eutils multilib-minimal

DESCRIPTION="A graphics library for fast image creation"
HOMEPAGE="http://libgd.org/ http://www.boutell.com/gd/"
SRC_URI="http://libgd.org/releases/${P}.tar.bz2"

LICENSE="gd IJG HPND BSD"
SLOT="2"
KEYWORDS="~alpha ~amd64 ~arm ~hppa ~ia64 ~m68k ~mips ~ppc ~ppc64 ~s390 ~sh ~sparc ~x86 ~amd64-fbsd ~sparc-fbsd ~x86-fbsd"
IUSE="fontconfig jpeg png static-libs truetype xpm zlib"

RDEPEND="fontconfig? ( media-libs/fontconfig[${MULTILIB_USEDEP}] )
	jpeg? ( virtual/jpeg:0[${MULTILIB_USEDEP}] )
	png? ( >=media-libs/libpng-1.2:0[${MULTILIB_USEDEP}] )
	truetype? ( >=media-libs/freetype-2.1.5[${MULTILIB_USEDEP}] )
	xpm? ( x11-libs/libXpm[${MULTILIB_USEDEP}] x11-libs/libXt[${MULTILIB_USEDEP}] )
	zlib? ( sys-libs/zlib[${MULTILIB_USEDEP}] )"
DEPEND="${RDEPEND}
	virtual/pkgconfig[${MULTILIB_USEDEP}]"

MULTILIB_CHOST_TOOLS=(
	/usr/bin/gdlib-config
)

src_prepare() {
	epatch "${FILESDIR}"/${P}-libpng14.patch #305101
	epatch "${FILESDIR}"/${P}-maxcolors.patch #292130
	epatch "${FILESDIR}"/${P}-fontconfig.patch #363367
	epatch "${FILESDIR}"/${P}-libpng-pkg-config.patch

	# Avoid programs we never install
	local make_sed=( -e '/^noinst_PROGRAMS/s:noinst:check:' )
	use png || make_sed+=( -e '/_PROGRAMS/s:(gdparttopng|gdtopng|gd2topng|pngtogd|pngtogd2|webpng)::g' )
	use zlib || make_sed+=( -e '/_PROGRAMS/s:(gd2topng|gd2copypal|gd2togif|giftogd2|gdparttopng|pngtogd2)::g' )
	sed -i -r "${make_sed[@]}" Makefile.am || die

	# bug 466996
	sed -i 's/AM_PROG_CC_STDC/AC_PROG_CC/' configure.ac || die

	cat <<-EOF > acinclude.m4
	m4_ifndef([AM_ICONV],[m4_define([AM_ICONV],[AC_SUBST(LIBICONV)])])
	EOF

	eautoreconf
}

multilib_src_configure() {
	export ac_cv_lib_z_deflate=$(usex zlib)
	# we aren't actually {en,dis}abling X here ... the configure
	# script uses it just to add explicit -I/-L paths which we
	# don't care about on Gentoo systems.
	ECONF_SOURCE=${S} \
	econf \
		--without-x \
		$(use_enable static-libs static) \
		$(use_with fontconfig) \
		$(use_with png) \
		$(use_with truetype freetype) \
		$(use_with jpeg) \
		$(use_with xpm)
}

multilib_src_install_all() {
	dodoc INSTALL README*
	dohtml -r ./
	prune_libtool_files
}
