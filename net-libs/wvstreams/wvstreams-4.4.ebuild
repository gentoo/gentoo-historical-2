# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-libs/wvstreams/wvstreams-4.4.ebuild,v 1.13 2010/01/04 16:10:51 ssuominen Exp $

EAPI=1

WANT_AUTOCONF=latest
WANT_AUTOMAKE=none

inherit eutils fixheadtails autotools

DESCRIPTION="A network programming library in C++"
HOMEPAGE="http://alumnit.ca/wiki/?WvStreams"
SRC_URI="http://wvstreams.googlecode.com/files/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="alpha amd64 hppa ppc sparc x86"
IUSE="qdbm pam slp doc debug"

RESTRICT="test"

RDEPEND=">=sys-libs/db-4
	>=sys-libs/zlib-1.2.3
	>=dev-libs/openssl-0.9.8e
	>=dev-libs/xplc-0.3.13
	qdbm? ( dev-db/qdbm )
	pam? ( virtual/pam )
	slp? ( >=net-libs/openslp-1.2.1 )"

DEPEND="${RDEPEND}
	dev-util/pkgconfig
	doc? ( app-doc/doxygen )"

src_unpack() {
	unpack ${A}

	epatch "${FILESDIR}/${P}-linux-serial.patch"
	epatch "${FILESDIR}/${P}-wireless-user.patch"
	epatch "${FILESDIR}/${P}-uniconfd-ini.patch"
	epatch "${FILESDIR}/${P}-as-needed.patch"
	epatch "${FILESDIR}/${P}-sane-cflags.patch"
	epatch "${FILESDIR}/${P}-type-punned.patch"
	epatch "${FILESDIR}/${P}-sigaction.patch"
	epatch "${FILESDIR}/${P}-wvconfemu.patch"
	epatch "${FILESDIR}/${P}-valgrind.patch"
	epatch "${FILESDIR}/${P}-gcc-4.3.patch"

	epatch "${FILESDIR}/${P}-external-xplc.patch"
	local XPLC_VER=`best_version dev-libs/xplc`
	XPLC_VER=${XPLC_VER#*/*-} #reduce it to ${PV}-${PR}
	XPLC_VER=${XPLC_VER%%[_-]*} # main version without beta/pre/patch/revision
	sed -i -e "s:^xplc_version=.*:xplc_version='${XPLC_VER}':" "${S}/configure.ac" \
		|| die "failed to set current xplc version"
	rm -r "${S}/xplc"

	ht_fix_file "${S}/configure.ac"

	#needed by xplc and as-needed patch:
	cd "${S}"
	eautoconf || die "autoconf failed"
	#without following, the makefile would remove some files and request
	#you to run ./configure again
	touch include/wvautoconf.h.in configure
}

src_compile() {
	econf \
		`use_with qdbm` \
		`use_with pam` \
		`use_with slp openslp` \
		--without-qt \
		`use_enable debug` \
		--without-tcl \
		--without-swig \
		--with-xplc \
		--enable-verbose \
		--with-bdb \
		--with-zlib \
		--with-openssl \
		|| die "configure failed"
	emake CXXOPTS="-fPIC -DPIC" COPTS="-fPIC -DPIC" || die "compile failed"
	use doc && doxygen
}

src_install() {
	emake CXXOPTS="-fPIC -DPIC" COPTS="-fPIC -DPIC" DESTDIR="${D}" install || die "make install failed"

	if use doc ; then
		#the list of files is too big for dohtml -r Docs/doxy-html/*
		cd Docs/doxy-html
		dohtml -r *
	fi
}
