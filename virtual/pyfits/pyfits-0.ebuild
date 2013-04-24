# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/virtual/pyfits/pyfits-0.ebuild,v 1.1 2013/04/24 20:43:48 bicatali Exp $

EAPI=5

PYTHON_COMPAT=( python{2_6,2_7,3_2,3_3} )

inherit python-r1

DESCRIPTION="Virtual for pyfits"
HOMEPAGE=""
SRC_URI=""

LICENSE=""
SLOT="0"
KEYWORDS="~amd64 ~x86 ~amd64-linux ~x86-linux"
IUSE=""

RDEPEND="|| ( >=dev-python/pyfits-3.1 >=dev-python/astropy-0.2 )"
