# Copyright 1999-2002 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-perl/CDDB_get/CDDB_get-1.66-r2.ebuild,v 1.1 2002/10/30 07:20:34 seemant Exp $

inherit perl-module

S="${WORKDIR}/${P}"
DESCRIPTION="Read the CDDB entry for an audio CD in your drive"
SRC_URI="http://armin.emx.at/cddb/${P}.tar.gz"
SLOT="0"
HOMEPAGE="http://armin.emx.at/cddb/"

SLOT="1"
LICENSE="Artistic | GPL-2"
KEYWORDS="x86 sparc sparc64 alpha"
