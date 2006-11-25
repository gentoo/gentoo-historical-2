# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-libs/flac/flac-1.1.3_beta2.ebuild,v 1.3 2006/11/25 11:07:23 flameeyes Exp $

WANT_AUTOCONF="latest"
WANT_AUTOMAKE="latest"

inherit libtool eutils toolchain-funcs autotools

MY_P="${P/_beta/-beta}"

PATCHLEVEL="9"
DESCRIPTION="free lossless audio encoder and decoder"
HOMEPAGE="http://flac.sourceforge.net/"
SRC_URI="mirror://sourceforge/flac/${MY_P}.tar.gz
	mirror://gentoo/${PN}-patches-${PATCHLEVEL}.tar.bz2"

LICENSE="GPL-2 LGPL-2"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~hppa ~ia64 ~mips ~ppc ~ppc-macos ~ppc64 ~sh ~sparc ~x86 ~x86-fbsd"
IUSE="3dnow debug doc ogg sse"

RDEPEND="ogg? ( >=media-libs/libogg-1.0_rc2 )"
DEPEND="${RDEPEND}
	x86? ( dev-lang/nasm )
	sys-apps/gawk
	doc? ( app-doc/doxygen )
	dev-util/pkgconfig"

RESTRICT="test"

S="${WORKDIR}/${MY_P}"

src_unpack() {
	unpack ${A}
	cd "${S}"

	# Enable only for GCC 4.1 and later
	[[ $(gcc-major-version)$(gcc-minor-version) -ge 41 ]] || \
		export EPATCH_EXCLUDE="130_all_visibility.patch 160_all_protected.patch"

	# Hard-disable the XMMS plugin now that XMMS is removed.
	sed -i -e '/AM_PATH_XMMS/d' "${S}/configure.in"

	EPATCH_SUFFIX="patch" \
	epatch "${WORKDIR}/patches"
	AT_M4DIR="m4" eautoreconf
	elibtoolize
}

src_compile() {
	econf \
		$(use_enable ogg) \
		$(use_enable sse) \
		$(use_enable 3dnow) \
		$(use_enable debug) \
		$(use_enable doc doxygen-docs) \
		--disable-dependency-tracking || die

	# the man page ebuild requires docbook2man... yick!
	sed -i -e 's:include man:include:g' Makefile

	emake || die "make failed"
}

src_install() {
	emake DESTDIR="${D}" docdir="/usr/share/doc/${PF}" \
		install || die "make install failed"
	dodoc AUTHORS README

	use doc || rm -rf "${D}/usr/share/doc/${PF}/api"

	doman man/{flac,metaflac}.1
}

pkg_postinst() {
	ewarn "If you've upgraded from a previous version of flac, you may need to re-emerge"
	ewarn "packages that linked against flac by running revdep-rebuild"
}
