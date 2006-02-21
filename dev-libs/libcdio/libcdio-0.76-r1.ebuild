# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-libs/libcdio/libcdio-0.76-r1.ebuild,v 1.2 2006/02/21 15:58:14 flameeyes Exp $

inherit eutils autotools

DESCRIPTION="A library to encapsulate CD-ROM reading and control"
HOMEPAGE="http://www.gnu.org/software/libcdio/"
SRC_URI="mirror://gnu/${PN}/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~hppa ~ia64 ~ppc ~ppc64 ~sh ~sparc ~x86"
IUSE="cddb minimal"

RDEPEND="!minimal? ( dev-libs/popt )
	cddb? ( >=media-libs/libcddb-1.0.1 )
	virtual/libintl"
DEPEND="${RDEPEND}
	sys-devel/gettext
	dev-util/pkgconfig"

src_unpack() {
	unpack ${A}
	cd "${S}"

	epatch "${FILESDIR}/${P}-dragonfly.patch"
	epatch "${FILESDIR}/${P}-nrg-crash.patch"

	AT_M4DIR="${S}" eautoreconf
}

src_compile() {
	econf \
		$(use_enable cddb) \
		$(use_with !minimal cd-drive) \
		$(use_with !minimal cd-info) \
		$(use_with !minimal cd-paranoia) \
		$(use_with !minimal cdda-player) \
		$(use_with !minimal cd-read) \
		$(use_with !minimal iso-info) \
		$(use_with !minimal iso-read) \
		--with-cd-paranoia-name=libcdio-paranoia \
		--disable-vcd-info \
		--disable-dependency-tracking || die "configure failed"
	# had problem with parallel make (phosphan@gentoo.org)
	emake -j1 || die "make failed"
}

src_install() {
	make DESTDIR="${D}" install || die "make install failed"
	dodoc AUTHORS ChangeLog NEWS README THANKS
}
