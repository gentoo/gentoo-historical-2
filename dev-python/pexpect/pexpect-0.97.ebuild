# Copyright 1999-2004 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-python/pexpect/pexpect-0.97.ebuild,v 1.7 2004/05/14 04:31:00 jhuebel Exp $

inherit distutils

IUSE=""
DESCRIPTION="Pexpect is a pure Python module for spawning child applications; controlling them; and responding to expected patterns in their output"
HOMEPAGE="http://pexpect.sourceforge.net/"
SRC_URI="mirror://sourceforge/pexpect/${P}.tgz"
LICENSE="PYTHON"
SLOT="0"
KEYWORDS="x86 ~ppc ~alpha sparc s390 ~amd64"
DEPEND="dev-lang/python"

mydoc="README.txt"
