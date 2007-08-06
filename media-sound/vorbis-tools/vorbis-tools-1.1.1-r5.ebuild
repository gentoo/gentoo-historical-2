# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-sound/vorbis-tools/vorbis-tools-1.1.1-r5.ebuild,v 1.1 2007/08/06 18:01:43 drac Exp $

IUSE="nls flac speex minimal"

WANT_AUTOCONF=2.5
WANT_AUTOMAKE=1.9

inherit eutils toolchain-funcs flag-o-matic autotools

DESCRIPTION="tools for using the Ogg Vorbis sound file format"
HOMEPAGE="http://www.vorbis.com/"
SRC_URI="http://downloads.xiph.org/releases/vorbis/${P}.tar.gz
	mirror://gentoo/${P}+flac-1.1.3.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~hppa ~ia64 ~ppc ~ppc64 ~sparc ~x86 ~x86-fbsd"

RDEPEND=">=media-libs/libvorbis-1.1.0
	!minimal? ( >=media-libs/libao-0.8.2
		>=net-misc/curl-7.9 )
	speex? ( media-libs/speex )
	flac? ( media-libs/flac )"

DEPEND="${RDEPEND}
	nls? ( sys-devel/gettext )"

pkg_setup() {
	if use flac && ! built_with_use media-libs/flac ogg; then
		eerror "To be able to play OggFlac files you need to build"
		eerror "media-libs/flac with +ogg, to build libOggFLAC."
		die "Missing libOggFLAC library."
	fi
}

src_unpack() {
	unpack ${A}
	cd "${S}"
	epatch "${FILESDIR}/${P}-utf8.patch"
	epatch "${WORKDIR}/${P}+flac-1.1.3-1.patch"
	epatch "${WORKDIR}/${P}+flac-1.1.3-2.patch"
	epatch "${WORKDIR}/${P}+flac-1.1.3-3.patch"
	epatch "${FILESDIR}/${P}-curl-7.16.0.patch"
	AT_M4DIR="m4" eautoreconf
}

src_compile() {
	# largefile support, bug 170677
	append-flags -D_FILE_OFFSET_BITS=64

	use hppa && [ "`gcc-fullversion`" == "3.3.2" ] && replace-flags -march=2.0 -march=1.0
	local myconf

	# --with-flac is not supported.  See bug #49763
	use flac || myconf="${myconf} --without-flac"
	# --with-speex is not supported. See bug #97316
	use speex || myconf="${myconf} --without-speex"
	# bug 143812
	use minimal && myconf="${myconf} --disable-ogg123"

	# for vcut see bug #143487
	econf \
		--enable-vcut \
		$(use_enable nls) \
		${myconf} || die "econf failed"
	emake || die "emake failed"
}

src_install() {
	make DESTDIR="${D}" install || die

	rm -rf ${D}/usr/share/doc
	dodoc AUTHORS README
	docinto ogg123
	dodoc ogg123/ogg123rc-example
}
