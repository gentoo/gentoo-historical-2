# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-util/cvs2svn/cvs2svn-1.2.1.ebuild,v 1.2 2005/05/07 10:57:13 dholm Exp $

inherit distutils

DESCRIPTION="Convert a CVS repository to a Subversion repository"
HOMEPAGE="http://cvs2svn.tigris.org/"
SRC_URI="http://cvs2svn.tigris.org/files/documents/1462/20727/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~x86 ~amd64 ~alpha ~ia64 ~ppc"
IUSE=""

DEPEND="dev-lang/python
	!<dev-util/subversion-1.0.9"
RDEPEND="${DEPEND}
	app-text/rcs"
