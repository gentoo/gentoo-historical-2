# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-cdr/xcdroast/xcdroast-0.98_alpha15-r5.ebuild,v 1.6 2008/06/15 03:22:57 drac Exp $

inherit eutils

DESCRIPTION="Old-school menu based front-end for CD and DVD writing"
HOMEPAGE="http://www.xcdroast.org/"
SRC_URI="mirror://sourceforge/xcdroast/${P/_/}.tar.gz
	mirror://gentoo/${P}_new_configure.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ppc sparc x86"
IUSE="nls"

RDEPEND=">=x11-libs/gtk+-2
	virtual/cdrtools"
DEPEND="${RDEPEND}
	dev-util/pkgconfig"

S=${WORKDIR}/${P/_/}

src_unpack() {
	unpack ${P/_/}.tar.gz
	cd "${S}"
	unpack ${P}_new_configure.tar.gz

	cd "${S}"/src
	epatch "${FILESDIR}"/gtk2locale.patch \
		"${FILESDIR}"/modern_cdrtools.patch \
		"${FILESDIR}"/cdrecord_versions.patch \
		"${FILESDIR}"/cdrecord2wodim.patch \
		"${FILESDIR}"/cdda2wav2icedax.patch \
		"${FILESDIR}"/mkisofs2genisoimage.patch
	use amd64 && epatch "${FILESDIR}"/64bit_gsize.patch
}

src_compile() {
	econf \
		$(use_enable nls) \
		--enable-gtk2 \
		--disable-dependency-tracking || die

	make PREFIX=/usr || die
}

src_install() {
	make PREFIX=/usr DESTDIR="${D}" install || die

	cd "${S}"/doc
	dodoc DOCUMENTATION FAQ README* TRANSLATION.HOWTO

	# move man pages to /usr/share/man to be LFH compliant
	mv "${D}"/usr/man "${D}"/usr/share

	# remove extraneous directory
	rm "${D}"/usr/etc -rf

	insinto /usr/share/icons/hicolor/48x48/apps
	newins "${S}"/xpms/xcdricon.xpm xcdroast.xpm

	make_desktop_entry xcdroast "X-CD-Roast" xcdroast "AudioVideo;DiscBurning"
}
