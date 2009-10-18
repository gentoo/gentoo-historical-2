# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/virtual/poppler-utils/poppler-utils-0.12.1.ebuild,v 1.1 2009/10/18 14:10:59 loki_val Exp $

EAPI=2

DESCRIPTION="Virtual package, includes packages that contain the psto* utilities"
HOMEPAGE="http://poppler.freedesktop.org/"
SRC_URI=""

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~hppa ~ia64 ~ppc ~ppc64 ~s390 ~sh ~sparc ~x86 ~x86-fbsd"
IUSE="+abiword png"

PROPERTIES="virtual"

RDEPEND="~app-text/poppler-utils-${PV}[abiword?,png?]"
DEPEND="${RDEPEND}"
