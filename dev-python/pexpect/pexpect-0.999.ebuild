# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-python/pexpect/pexpect-0.999.ebuild,v 1.9 2005/04/21 18:59:31 hansmi Exp $

inherit distutils

DESCRIPTION="Pexpect is a pure Python module for spawning child applications; controlling them; and responding to expected patterns in their output"
HOMEPAGE="http://pexpect.sourceforge.net/"
SRC_URI="mirror://sourceforge/pexpect/${P}.tgz"

LICENSE="PYTHON"
SLOT="0"
KEYWORDS="alpha amd64 ppc ~ppc-macos s390 sparc x86"
IUSE=""

DEPEND="dev-lang/python"

mydoc="README.txt"
