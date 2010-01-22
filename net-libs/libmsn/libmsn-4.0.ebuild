# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-libs/libmsn/libmsn-4.0.ebuild,v 1.2 2010/01/22 08:52:24 abcd Exp $

EAPI=2
inherit cmake-utils

DESCRIPTION="Library for connecting to Microsoft's MSN Messenger service."
HOMEPAGE="http://sourceforge.net/projects/libmsn/"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~hppa ~ia64 ~ppc ~ppc64 ~sparc ~x86 ~amd64-linux ~x86-linux"
IUSE="debug"

DEPEND="dev-libs/openssl"

DOCS="ChangeLog README THANKS TODO"
