# Copyright 1999-2004 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-gfx/etcher/etcher-1.0.20031013.ebuild,v 1.5 2004/06/24 22:36:04 agriffis Exp $

inherit enlightenment

DESCRIPTION="graphical editing tool for creating and manipulating Ebits GUI elements"
HOMEPAGE="http://www.enlightenment.org/pages/etcher.html"

DEPEND="=x11-libs/gtk+-1*
	>=media-libs/imlib2-1.1.0
	>=x11-libs/evas-1.0.0.20031013_pre12
	>=dev-db/edb-1.0.4.20031013
	>=media-libs/ebits-1.0.1.20031013"

src_compile() {
	export MY_ECONF="`use_enable nls`"
	enlightenment_src_compile
}
