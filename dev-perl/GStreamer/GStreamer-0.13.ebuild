# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-perl/GStreamer/GStreamer-0.13.ebuild,v 1.1 2008/12/17 16:52:20 tove Exp $

MODULE_AUTHOR=TSCH
inherit perl-module

DESCRIPTION="Perl bindings for GStreamer"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~sparc ~x86"
IUSE=""

RDEPEND="=media-libs/gstreamer-0.10*
	>=dev-perl/glib-perl-1.180"
DEPEND="${RDEPEND}
	>=dev-perl/extutils-depends-0.205
	>=dev-perl/extutils-pkgconfig-1.07
	dev-util/pkgconfig"
