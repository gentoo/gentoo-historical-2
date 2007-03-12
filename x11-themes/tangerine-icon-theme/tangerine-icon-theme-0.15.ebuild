# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/x11-themes/tangerine-icon-theme/tangerine-icon-theme-0.15.ebuild,v 1.4 2007/03/12 13:22:53 gustavoz Exp $

inherit eutils

DESCRIPTION="a derivative of the standard Tango theme, using a more orange approach"
HOMEPAGE="http://packages.ubuntu.com/feisty/x11/tangerine-icon-theme"
SRC_URI="http://archive.ubuntu.com/ubuntu/pool/main/t/${PN}/${PN}_${PV}.orig.tar.gz
	http://www.gentoo.org/images/gentoo-logo.svg"

LICENSE="CCPL-Attribution-ShareAlike-2.5"
SLOT="0"
KEYWORDS="~amd64 ~sparc ~x86"
IUSE="png"

RESTRICT="binchecks strip"

RDEPEND=">=x11-misc/icon-naming-utils-0.8.2
	media-gfx/imagemagick
	>=gnome-base/librsvg-2.12.3
	>=x11-themes/tango-icon-theme-0.8"
DEPEND="${RDEPEND}
	>=dev-util/pkgconfig-0.19
	>=dev-util/intltool-0.33
	sys-devel/gettext"

pkg_setup() {
	if use png && ! built_with_use media-gfx/imagemagick png; then
		die "Build media-gfx/imagemagick with USE=png."
	fi
}

src_unpack() {
	unpack ${A}
	cp "${DISTDIR}"/gentoo-logo.svg "${S}"/scalable/places/start-here.svg
}

src_compile() {
	econf $(use_enable png png-creation) \
		$(use_enable png icon-framing)
	emake || die "emake failed."
}

src_install() {
	addwrite "/root/.gnome2"

	emake DESTDIR=${D} install || die "emake install failed."
	dodoc AUTHORS ChangeLog NEWS README
}
