# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/xfce-extra/thunar-thumbnailers/thunar-thumbnailers-0.1.1.ebuild,v 1.5 2007/04/24 20:36:54 gustavoz Exp $

inherit xfce44

xfce44

DESCRIPTION="Thunar thumbnailers plugin"
HOMEPAGE="http://goodies.xfce.org/projects/thunar-plugins/thunar-thumbnailers"
SRC_URI="http://goodies.xfce.org/releases/${PN}/${P}${COMPRESS}"

KEYWORDS="amd64 ~ppc64 x86"
IUSE="dcraw grace tetex"

RDEPEND=">=xfce-base/thunar-${THUNAR_MASTER_VERSION}
	media-gfx/imagemagick
	dcraw? ( media-gfx/dcraw )
	grace? ( sci-visualization/grace )
	tetex? ( virtual/tetex )"
DEPEND="${RDEPEND}
	dev-util/pkgconfig"

XFCE_CONFIG="${XFCE_CONFIG} $(use_enable tetex tex) $(use_enable dcraw raw) \
	$(use_enable grace) --disable-update-mime-database"

DOCS="AUTHORS ChangeLog NEWS README"

pkg_postinst() {
	xfce44_pkg_postinst
	elog "Run /usr/libexec/thunar-vfs-update-thumbnailers-cache-1 as a user to enable
	thumbnailers."
}
