# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-crypt/p11-kit/p11-kit-0.12.ebuild,v 1.6 2012/03/31 14:51:10 maekke Exp $

EAPI=4

inherit autotools-utils

DESCRIPTION="Provides a standard configuration setup for installing PKCS#11."
HOMEPAGE="http://p11-glue.freedesktop.org/p11-kit.html"
SRC_URI="http://p11-glue.freedesktop.org/releases/${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~alpha amd64 arm hppa ~ppc ppc64 x86 ~x86-fbsd"
IUSE="debug"

src_configure() {
	local myeconfargs=(
		$(use_enable debug)
	)
	autotools-utils_src_configure
}
