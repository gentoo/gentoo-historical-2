# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/x11-themes/tango-icon-theme-extras/tango-icon-theme-extras-0.1.0-r1.ebuild,v 1.3 2007/03/10 19:40:13 drac Exp $

inherit eutils

DESCRIPTION="This is an extension to the Tango Icon Theme. It includes Tango icons for iPod Digital Audio Player (DAP) devices and the Dell Pocket DJ DAP."
HOMEPAGE="http://tango-project.org/"
SRC_URI="http://tango-project.org/releases/${P}.tar.gz"

LICENSE="CCPL-Attribution-ShareAlike-2.5"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~ppc64 ~sparc ~x86"
IUSE="png"

RESTRICT="binchecks strip"

RDEPEND=">=x11-misc/icon-naming-utils-0.6.0
	media-gfx/imagemagick
	>=gnome-base/librsvg-2.12.3
	>=x11-themes/tango-icon-theme-0.8"
DEPEND="${RDEPEND}
	dev-util/pkgconfig"

pkg_setup() {
	if use png && ! built_with_use media-gfx/imagemagick png; then
		die "Build media-gfx/imagemagick with USE=png."
	fi
}

src_compile() {
	econf $(use_enable png png-creation) \
		$(use_enable png icon-framing)
	emake || die "emake failed."
}

src_install() {
	emake DESTDIR="${D}" install || "emake install failed."
	dodoc AUTHORS ChangeLog NEWS README
}
