# Copyright 1999-2002 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License, v2 or later
# Maintainer: Matthew Turk <m-turk@nwu.edu>
# $Header: /var/cvsroot/gentoo-x86/app-text/latex-leaflet/latex-leaflet-19990601.ebuild,v 1.4 2002/05/21 23:52:29 blocke Exp $

inherit latex-package

S=${WORKDIR}/leaflet
DESCRIPTION="LaTeX package used to create leaflet-type brochures."
SRC_URI="http://www.ibiblio.org/gentoo/distfiles/${P}.tar.gz"
HOMEPAGE="ftp://ibiblio.org/pub/packages/TeX/macros/latex/contrib/supported/"
LICENSE="LPPL"
SLOT="0"

# checksum from official ftp site changes frequently so we mirror it

