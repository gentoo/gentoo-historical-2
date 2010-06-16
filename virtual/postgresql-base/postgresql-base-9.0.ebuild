# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/virtual/postgresql-base/postgresql-base-9.0.ebuild,v 1.1 2010/06/16 18:15:06 patrick Exp $

EAPI="1"

DESCRIPTION="Virtual for PostgreSQL base (clients + libraries)"
HOMEPAGE=""
SRC_URI=""

LICENSE=""
SLOT="${PV}"
KEYWORDS="~alpha ~amd64 ~arm ~hppa ~ia64 ~ppc ~ppc64 ~s390 ~sh ~sparc ~x86 ~x86-fbsd ~x86-freebsd ~amd64-linux ~x86-linux ~x64-macos ~x86-macos ~x86-solaris"
IUSE=""

RDEPEND="dev-db/postgresql-base:${SLOT}"
