# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/xfce-extra/xfce4-mixer/xfce4-mixer-4.4.1.ebuild,v 1.7 2007/05/24 21:06:20 pylon Exp $

inherit eutils xfce44

XFCE_VERSION=4.4.1
xfce44

# Bugs 166167 and 174296. Parallel make is dead in xfce4-mixer.
xfce44_single_make

DESCRIPTION="Volume control application (ALSA or OSS)"
HOMEPAGE="http://www.xfce.org/projects/xfce4-mixer"
KEYWORDS="alpha amd64 ~arm hppa ia64 ~mips ppc ~ppc64 sparc x86 ~x86-fbsd"

IUSE="alsa debug"

RDEPEND=">=dev-libs/glib-2.6
	dev-libs/libxml2
	>=x11-libs/gtk+-2.6
	>=xfce-base/xfce-mcs-manager-${XFCE_MASTER_VERSION}
	>=xfce-base/xfce4-panel-${XFCE_MASTER_VERSION}
	alsa? ( media-libs/alsa-lib )"
DEPEND="${RDEPEND}
	dev-util/pkgconfig
	dev-util/intltool"

if use alsa; then
	XFCE_CONFIG="${XFCE_CONFIG} --with-sound=alsa"
fi

DOCS="AUTHORS ChangeLog NEWS NOTES README TODO"

src_install() {
	xfce44_src_install
	make_desktop_entry ${PN} "Volume control" ${PN} AudioVideo
}

xfce44_core_package
