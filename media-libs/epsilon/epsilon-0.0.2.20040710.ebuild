# Copyright 1999-2004 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-libs/epsilon/epsilon-0.0.2.20040710.ebuild,v 1.1 2004/07/12 12:34:37 vapier Exp $

inherit enlightenment

DESCRIPTION="nice thumbnail generator"

DEPEND="${DEPEND}
	media-libs/imlib2
	media-libs/epeg
	media-libs/libpng"
