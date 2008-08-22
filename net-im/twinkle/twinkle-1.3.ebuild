# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-im/twinkle/twinkle-1.3.ebuild,v 1.1 2008/08/22 23:41:37 dragonheart Exp $

EAPI=1
ARTS_REQUIRED="never"
inherit eutils qt3 kde

DESCRIPTION="a soft phone for your VOIP communcations using SIP"
HOMEPAGE="http://www.twinklephone.com/"
SRC_URI="http://www.xs4all.nl/~mfnboer/twinkle/download/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~ppc64 ~x86"
IUSE="arts speex ilbc zrtp kdehiddenvisibility"

# Requires libqt-mt actually...  Is that *always* built, or do we need to check?
RDEPEND=">=net-libs/ccrtp-1.6.0
	>=dev-cpp/commoncpp2-1.6.1
	x11-libs/qt:3
	media-libs/libsndfile
	dev-libs/boost
	speex? ( media-libs/speex )
	ilbc? ( dev-libs/ilbc-rfc3951 )
	zrtp? ( >=net-libs/libzrtpcpp-1.3.0 )
	media-libs/alsa-lib"

DEPEND="${RDEPEND}
	dev-util/pkgconfig"

pkg_setup() {
	if use speex && has_version '~media-libs/speex-1.2_beta2' &&
		! built_with_use 'media-libs/speex' 'wideband' ; then
		eerror "You need to build media-libs/speex with USE=wideband enabled."
		die "Speex w/o wideband-support detected."
	fi
}

src_unpack() {
	unpack ${A}
	epatch "${FILESDIR}"/${P}-gcc4.3.patch
}

src_compile() {
	local myconf=" \
			$(use_with ilbc) \
			$(use_with arts) \
			$(use_with zrtp) \
			$(use_with speex)"
	set-kdedir
	kde_src_compile
}

src_install() {
	kde_src_install
	dodoc THANKS
	domenu twinkle.desktop
}
