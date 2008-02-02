# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/www-client/pybugz/pybugz-0.7.3.ebuild,v 1.5 2008/02/02 14:08:18 ranger Exp $

inherit distutils

DESCRIPTION="Command line interface to (Gentoo) Bugzilla"
HOMEPAGE="http://pybugz.googlecode.com"
SRC_URI="http://pybugz.googlecode.com/files/${P}.tar.gz"
LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~alpha amd64 ~arm ~ia64 ~ppc ppc64 ~sparc x86 ~x86-fbsd"
IUSE=""
DEPEND="|| ( >=dev-lang/python-2.5
	( >=dev-lang/python-2.4
		dev-python/elementtree ) )"

		pkg_setup() {
			if ! built_with_use dev-lang/python readline; then
				eerror
				eerror "Python is not built with readline support."
				eerror "Please re-emerge python with readline  in your use flags."
				die "python must be built with readline support."
	fi
		}
