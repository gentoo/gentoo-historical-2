# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-php/smarty-docs/smarty-docs-2.6.11.ebuild,v 1.7 2007/03/12 16:42:05 armin76 Exp $

DESCRIPTION="Documentation for Smarty, a template engine for PHP."
HOMEPAGE="http://smarty.php.net/docs.php"
LICENSE="LGPL-2.1"
SLOT="0"
IUSE=""
KEYWORDS="alpha amd64 hppa ppc ~ppc64 sparc x86"

MY_P="Smarty-${PV}-docs"
SRC_URI="http://smarty.php.net/distributions/manual/en/${MY_P}.tar.gz"
S="${WORKDIR}/manual"

src_install() {
	dohtml -r .
}
