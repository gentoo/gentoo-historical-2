# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-python/mysql-python/mysql-python-1.2.3_rc1.ebuild,v 1.9 2010/01/27 19:26:55 armin76 Exp $

NEED_PYTHON=2.3

inherit distutils

MY_P="MySQL-python-${PV/_rc/c}"
DESCRIPTION="MySQL Module for python"
HOMEPAGE="http://sourceforge.net/projects/mysql-python/"
SRC_URI="mirror://sourceforge/mysql-python/${MY_P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="alpha amd64 ~arm hppa ia64 ppc ppc64 sparc x86 ~x86-fbsd ~x86-freebsd ~amd64-linux ~x86-linux ~ppc-macos ~x86-macos ~sparc-solaris ~x86-solaris"
IUSE=""

RDEPEND="virtual/mysql"
DEPEND="${RDEPEND}
	dev-python/setuptools"

S="${WORKDIR}/${MY_P}"
DOCS="HISTORY doc/FAQ.txt doc/MySQLdb.txt"
