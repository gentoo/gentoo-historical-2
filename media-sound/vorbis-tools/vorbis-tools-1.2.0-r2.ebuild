# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-sound/vorbis-tools/vorbis-tools-1.2.0-r2.ebuild,v 1.3 2008/11/14 04:01:31 jer Exp $

EAPI=1

inherit base autotools eutils

DESCRIPTION="tools for using the Ogg Vorbis sound file format"
HOMEPAGE="http://www.vorbis.com"
SRC_URI="http://downloads.xiph.org/releases/vorbis/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm hppa ~ia64 ~mips ~ppc ppc64 ~sparc ~x86 ~x86-fbsd"
IUSE="flac nls +ogg123 speex"

RDEPEND=">=media-libs/libvorbis-1.1
	flac? ( media-libs/flac )
	ogg123? ( media-libs/libao net-misc/curl )
	speex? ( media-libs/speex )"
DEPEND="${RDEPEND}
	nls? ( sys-devel/gettext )
	dev-util/pkgconfig"

PATCHES=( "${FILESDIR}/${P}-with-args.patch"
	"${FILESDIR}"/${P}-sec.patch
	"${FILESDIR}"/${P}-oggenc-resample-call-fix.patch )

src_unpack() {
	base_src_unpack
	cd "${S}"
	AT_M4DIR="m4" eautoreconf
}

src_compile() {
	econf	--enable-vcut \
		$(use_enable nls) \
		$(use_enable ogg123) \
		$(use_with flac) \
		$(use_with speex)

	emake || die "emake failed."
}

src_install() {
	emake docdir=/usr/share/doc/${PF} DESTDIR="${D}" \
		install || die "emake install failed."

	dodoc AUTHORS CHANGES README
	prepalldocs
}
