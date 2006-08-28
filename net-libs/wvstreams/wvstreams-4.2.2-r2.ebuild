# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-libs/wvstreams/wvstreams-4.2.2-r2.ebuild,v 1.3 2006/08/28 05:33:52 mrness Exp $

inherit eutils fixheadtails

DESCRIPTION="A network programming library in C++"
HOMEPAGE="http://open.nit.ca/wiki/?page=WvStreams"
SRC_URI="http://open.nit.ca/download/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~hppa ~ppc ~sparc ~x86"
IUSE="qt3 qdbm pam slp doc debug"

RESTRICT="test"

RDEPEND=">=sys-libs/db-3
	>=sys-libs/zlib-1.1.4
	>=dev-libs/openssl-0.9.7
	>=dev-libs/xplc-0.3.13
	qt3? ( =x11-libs/qt-3* )
	qdbm? ( dev-db/qdbm )
	pam? ( >=sys-libs/pam-0.75 )
	slp? ( >=net-libs/openslp-1.0.9a )
	doc? ( app-doc/doxygen )"

DEPEND="${RDEPEND}
	dev-util/pkgconfig
	>=sys-devel/autoconf-2.59"

src_unpack() {
	unpack ${A}

	epatch "${FILESDIR}/${P}-gcc41.patch"
	epatch "${FILESDIR}/${P}-linux-serial.patch"
	epatch "${FILESDIR}/${P}-wireless-user.patch"
	epatch "${FILESDIR}/${P}-uniconfd-ini.patch"
	epatch "${FILESDIR}/${P}-as-needed.patch"

	epatch "${FILESDIR}/${P}-external-xplc.patch"
	local XPLC_VER=`best_version dev-libs/xplc`
	XPLC_VER=${XPLC_VER#*/*-} #reduce it to ${PV}-${PR}
	XPLC_VER=${XPLC_VER%%[_-]*} # main version without beta/pre/patch/revision
	sed -i -e "s:^xplc_version=.*:xplc_version='${XPLC_VER}':" "${S}/configure.ac" \
		|| die "failed to set current xplc version"
	rm -r "${S}/xplc"

	use qt3 && epatch "${FILESDIR}/${P}-MOC-fix.patch"

	ht_fix_file "${S}/configure.ac"

	#needed by xplc and as-needed patch:
	cd "${S}"
	env WANT_AUTOCONF=2.5 autoconf || die "autoconf failed"
	#without following, the makefile would remove some files and request 
	#you to run ./configure again
	touch include/wvautoconf.h.in configure
}

src_compile() {
	local myconf
	if use qt3; then
		myconf="--with-qt=/usr/qt/3/"
		export MOC="/usr/qt/3/bin/moc"
	else
		myconf="--without-qt"
	fi
	econf ${myconf} \
		`use_with qdbm` \
		`use_with pam` \
		`use_with slp openslp` \
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
	make DESTDIR="${D}" install || die "make install failed"

	if use doc ; then
		#the list of files is too big for dohtml -r Docs/doxy-html/*
		cd Docs/doxy-html &&
			dohtml -r *
	fi
}
