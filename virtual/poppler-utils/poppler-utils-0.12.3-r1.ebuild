# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/virtual/poppler-utils/poppler-utils-0.12.3-r1.ebuild,v 1.5 2010/02/03 22:14:27 maekke Exp $

EAPI=2

DESCRIPTION="Virtual package, includes packages that contain the psto* utilities"
HOMEPAGE=""
SRC_URI=""

LICENSE=""
SLOT="0"
KEYWORDS="~alpha amd64 ~arm hppa ~ia64 ~ppc ppc64 ~s390 ~sh ~sparc x86 ~sparc-fbsd ~x86-fbsd ~x86-interix ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~x86-macos ~sparc-solaris ~x64-solaris ~x86-solaris"
IUSE="+abiword png"

PROPERTIES="virtual"

RDEPEND="~app-text/poppler-${PV}[abiword?,png?,utils]"
DEPEND="${RDEPEND}"
