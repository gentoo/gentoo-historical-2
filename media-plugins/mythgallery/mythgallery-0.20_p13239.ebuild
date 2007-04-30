# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-plugins/mythgallery/mythgallery-0.20_p13239.ebuild,v 1.3 2007/04/30 02:02:01 cardoe Exp $

inherit mythtv-plugins

DESCRIPTION="Gallery and slideshow module for MythTV."
KEYWORDS="amd64 ppc x86"
IUSE="exif"

RDEPEND="exif? ( >=media-libs/libexif-0.6.10 )
	media-libs/tiff"
DEPEND="${RDEPEND}"

MTVCONF="$(use_enable exif) $(use_enable exif new-exif)"
