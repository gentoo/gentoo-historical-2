# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-perl/CDDB_get/CDDB_get-2.25.ebuild,v 1.7 2006/01/31 20:08:33 agriffis Exp $

inherit perl-module

DESCRIPTION="Read the CDDB entry for an audio CD in your drive"
SRC_URI="http://armin.emx.at/cddb/${P}.tar.gz"
HOMEPAGE="http://armin.emx.at/cddb/"

SLOT="2"
LICENSE="|| ( Artistic GPL-2 )"
KEYWORDS="alpha ~amd64 ~ia64 ppc ppc64 sparc x86"
IUSE=""

SRC_TEST="do"
