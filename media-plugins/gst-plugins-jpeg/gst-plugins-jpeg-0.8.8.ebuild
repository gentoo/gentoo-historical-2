# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-plugins/gst-plugins-jpeg/gst-plugins-jpeg-0.8.8.ebuild,v 1.2 2005/04/25 12:00:35 zaheerm Exp $

inherit gst-plugins

DESCRIPTION="plug-in to encode and decode jpeg images"

KEYWORDS="x86 ~ppc ~amd64"
IUSE=""

RDEPEND="media-libs/jpeg"

DEPEND="${RDEPEND}
	>=dev-util/pkgconfig-0.9"
