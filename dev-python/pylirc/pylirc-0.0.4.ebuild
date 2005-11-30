# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-python/pylirc/pylirc-0.0.4.ebuild,v 1.1.1.1 2005/11/30 10:10:29 chriswhite Exp $

inherit distutils

DESCRIPTION="lirc module for Python."
HOMEPAGE="http://sourceforge.net/projects/pylirc/"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="x86 ppc amd64"
IUSE=""

DEPEND="${DEPEND}
	app-misc/lirc"
