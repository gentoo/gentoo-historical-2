# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-libs/ding-libs/ding-libs-0.1.2.ebuild,v 1.1 2011/08/11 21:33:59 maksbotan Exp $

EAPI=4

inherit autotools-utils

DESCRIPTION="Library set needed for build sssd"
HOMEPAGE="https://fedorahosted.org/sssd"
SRC_URI="https://fedorahosted.org/released/${PN}/${P}.tar.gz"

LICENSE="LGPL-3"
SLOT="0"

KEYWORDS="~amd64 ~amd64-linux ~x86"
IUSE="test static-libs"

#Obsolete blocks on old packages, to be removed soon
RDEPEND="!!dev-libs/libcollection
	!!dev-libs/libdhash
	!!dev-libs/libini_config
	!!dev-libs/libpath_utils
	!!dev-libs/libref_array"
DEPEND="${RDEPEND}
	test? ( dev-libs/check )"

AUTOTOOLS_IN_SOURCE_BUILD=1
