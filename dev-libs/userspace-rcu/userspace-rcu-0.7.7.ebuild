# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-libs/userspace-rcu/userspace-rcu-0.7.7.ebuild,v 1.1 2013/07/15 08:39:08 radhermit Exp $

EAPI=5

inherit autotools-utils

DESCRIPTION="userspace RCU (read-copy-update) library"
HOMEPAGE="http://lttng.org/urcu"
SRC_URI="http://lttng.org/files/urcu/${P}.tar.bz2"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="static-libs test"

DEPEND="test? ( sys-process/time )"

# tests fail with separate build dirs
AUTOTOOLS_IN_SOURCE_BUILD=1

src_configure() {
	myeconfargs=(
		--docdir="${EPREFIX}/usr/share/doc/${PF}"
	)
	autotools-utils_src_configure
}
