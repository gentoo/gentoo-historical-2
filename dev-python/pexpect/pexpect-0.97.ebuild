# Copyright 1999-2003 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-python/pexpect/pexpect-0.97.ebuild,v 1.1 2003/04/04 19:19:39 liquidx Exp $

inherit distutils

IUSE=""
DESCRIPTION="Pexpect is a pure Python module for spawning child applications; controlling them; and responding to expected patterns in their output"
HOMEPAGE="http://pexpect.sourceforge.net/"
SRC_URI="mirror://sourceforge/pexpect/${P}.tgz"
LICENSE="PYTHON"
SLOT="0"
KEYWORDS="~x86 ~ppc ~alpha ~sparc"
DEPEND="dev-lang/python"

mydoc="README.txt"
