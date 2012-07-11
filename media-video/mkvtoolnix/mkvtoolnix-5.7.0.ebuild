# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-video/mkvtoolnix/mkvtoolnix-5.7.0.ebuild,v 1.1 2012/07/11 07:41:41 radhermit Exp $

EAPI=4
inherit eutils toolchain-funcs versionator wxwidgets

DESCRIPTION="Tools to create, alter, and inspect Matroska files"
HOMEPAGE="http://www.bunkus.org/videotools/mkvtoolnix"
SRC_URI="http://www.bunkus.org/videotools/mkvtoolnix/sources/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="bzip2 debug lzo pch qt4 wxwidgets"

RDEPEND="
	>=dev-libs/libebml-1.2.2
	>=media-libs/libmatroska-1.3.0
	>=dev-libs/boost-1.46.0
	dev-libs/pugixml
	media-libs/flac
	media-libs/libogg
	media-libs/libvorbis
	sys-apps/file
	>=sys-devel/gcc-4.6
	sys-libs/zlib
	bzip2? ( app-arch/bzip2 )
	lzo? ( dev-libs/lzo )
	qt4? (
		x11-libs/qt-core:4
		x11-libs/qt-gui:4
	)
	wxwidgets? ( x11-libs/wxGTK:2.8[X] )
"
DEPEND="${RDEPEND}
	dev-ruby/rake
	virtual/pkgconfig
"

pkg_setup() {
	# http://bugs.gentoo.org/419257
	local ver=4.6
	local msg="You need at least GCC ${ver}.x for C++11 range-based 'for' and nullptr support."
	if ! version_is_at_least ${ver} $(gcc-version); then
		eerror ${msg}
		die ${msg}
	fi
}

src_prepare() {
	epatch "${FILESDIR}"/${PN}-5.6.0-system-pugixml.patch
}

src_configure() {
	local myconf

	use pch || myconf+=" --disable-precompiled-headers"

	if use wxwidgets ; then
		WX_GTK_VER="2.8"
		need-wxwidgets unicode
		myconf+=" --with-wx-config=${WX_CONFIG}"
	fi

	econf \
		$(use_enable bzip2 bz2) \
		$(use_enable debug) \
		$(use_enable lzo) \
		$(use_enable qt4 qt) \
		$(use_enable wxwidgets) \
		${myconf} \
		--docdir=/usr/share/doc/${PF} \
		--with-boost-regex=boost_regex \
		--with-boost-filesystem=boost_filesystem \
		--with-boost-system=boost_system \
		--without-curl
}

src_compile() {
	rake || die "rake failed"
}

src_install() {
	# Don't run strip while installing stuff, leave to portage the job.
	DESTDIR="${D}" rake install || die

	dodoc AUTHORS ChangeLog README TODO
	doman doc/man/*.1

	use wxwidgets && docompress -x /usr/share/doc/${PF}/guide
}
