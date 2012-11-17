# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-libs/libmikmod/libmikmod-3.2.0.ebuild,v 1.1 2012/11/17 17:53:17 ssuominen Exp $

EAPI=5
inherit autotools eutils multilib

DESCRIPTION="A library to play a wide range of module formats"
HOMEPAGE="http://mikmod.shlomifish.org/"
SRC_URI="http://mikmod.shlomifish.org/files/${P}.tar.gz"

LICENSE="LGPL-2+ LGPL-2.1"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~hppa ~ia64 ~mips ~ppc ~ppc64 ~sh ~sparc ~x86 ~x86-fbsd ~x86-freebsd ~amd64-linux ~x86-linux ~ppc-macos ~x86-macos"
IUSE="+alsa oss static-libs"

REQUIRED_USE="|| ( alsa oss )"

RDEPEND="alsa? ( media-libs/alsa-lib )
	!${CATEGORY}/${PN}:2"
DEPEND="${RDEPEND}
	oss? ( virtual/os-headers )"

src_prepare() {
	EPATCH_SOURCE="${FILESDIR}"/${PVR} EPATCH_SUFFIX=patch epatch

	touch macintosh/_libmikmodversion.r
	eautoreconf
}

src_configure() {
	econf \
		$(use_enable alsa) \
		--disable-nas \
		$(use_enable oss) \
		$(use_enable static-libs static)
}

src_install() {
	default
	dohtml docs/*.html

	prune_libtool_files
	dosym ${PN}$(get_libname 3) /usr/$(get_libdir)/${PN}$(get_libname 2)

	cat <<-EOF > "${T}"/libmikmod.pc
	prefix=/usr
	exec_prefix=\${prefix}
	libdir=/usr/$(get_libdir)
	includedir=\${prefix}/include
	Name: libmikmod
	Description: ${DESCRIPTION}
	Version: ${PV}
	Libs: -L\${libdir} -lmikmod
	Libs.private: -ldl -lm
	Cflags: -I\${includedir} $("${ED}"/usr/bin/libmikmod-config --cflags)
	EOF

	insinto /usr/$(get_libdir)/pkgconfig
	doins "${T}"/${PN}.pc
}
