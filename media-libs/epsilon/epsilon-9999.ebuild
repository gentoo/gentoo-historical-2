# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-libs/epsilon/epsilon-9999.ebuild,v 1.1.1.1 2005/11/30 10:04:05 chriswhite Exp $

EHACKAUTOGEN=yes
inherit enlightenment

DESCRIPTION="nice thumbnail generator"

DEPEND=">=media-libs/imlib2-1.2.0
	>=media-libs/epeg-0.9.0
	media-libs/libpng"
