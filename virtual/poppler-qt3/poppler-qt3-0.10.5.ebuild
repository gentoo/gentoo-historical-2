# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/virtual/poppler-qt3/poppler-qt3-0.10.5.ebuild,v 1.3 2009/04/01 14:51:24 loki_val Exp $

EAPI=2

DESCRIPTION="Virtual package, includes packages that contain libpoppler-qt.so"
HOMEPAGE="http://poppler.freedesktop.org/"
SRC_URI=""

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~hppa ~ia64 ~ppc ~ppc64 ~sh ~sparc ~x86 ~x86-fbsd"
IUSE=""

PROPERTIES="virtual"

RDEPEND="|| ( ~dev-libs/poppler-qt3-${PV} ~app-text/poppler-bindings-${PV}[qt3] )"
DEPEND="${RDEPEND}"
