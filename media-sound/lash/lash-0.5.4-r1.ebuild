# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-sound/lash/lash-0.5.4-r1.ebuild,v 1.1 2008/10/10 12:27:11 flameeyes Exp $

EAPI=2

inherit eutils libtool

DESCRIPTION="LASH Audio Session Handler"
HOMEPAGE="http://www.nongnu.org/lash/"
SRC_URI="http://download.savannah.gnu.org/releases/lash/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~ppc ~ppc64 ~sparc ~x86"
IUSE="alsa debug gtk python"

RDEPEND="alsa? ( media-libs/alsa-lib[midi] )
	media-sound/jack-audio-connection-kit
	dev-libs/libxml2
	gtk? ( >=x11-libs/gtk+-2.0 )
	python? ( dev-lang/python )
	|| ( sys-libs/readline dev-libs/libedit )"
DEPEND="${RDEPEND}
	dev-util/pkgconfig
	python? ( >=dev-lang/swig-1.3.31 )"

src_unpack() {
	unpack ${A}
	cd "${S}"
	epatch "${FILESDIR}/${P}-glibc2.8.patch"
	elibtoolize
}

src_configure() {
	local myconf

	# Yet-another-broken-configure: --enable-pylash would disable it.
	use python || myconf="${myconf} --disable-pylash"

	econf \
		$(use_enable alsa alsa-midi) \
		$(use_enable gtk gtk2) \
		$(use_enable debug) \
		${myconf} \
		--disable-dependency-tracking \
		|| die "econf failed"
}

src_install() {
	emake DESTDIR="${D}" install || die

	dodoc AUTHORS ChangeLog NEWS README TODO
}
