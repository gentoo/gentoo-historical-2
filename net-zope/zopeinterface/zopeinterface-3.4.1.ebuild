# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-zope/zopeinterface/zopeinterface-3.4.1.ebuild,v 1.4 2009/04/26 15:57:25 armin76 Exp $

inherit distutils

MY_PN="zope.interface"
MY_P="${MY_PN}-${PV}"
DESCRIPTION="Standalone Zope interface library"
HOMEPAGE="http://pypi.python.org/pypi/zope.interface/"
SRC_URI="http://pypi.python.org/packages/source/z/${MY_PN}/${MY_P}.tar.gz"

LICENSE="ZPL"
SLOT="0"
KEYWORDS="alpha amd64 arm ~hppa ia64 ~mips ~ppc ppc64 s390 sh sparc x86 ~x86-fbsd"
IUSE=""

RDEPEND=">=dev-lang/python-2.3"

S=${WORKDIR}/${MY_P}
DOCS="CHANGES.txt"
