# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-perl/WWW-Curl/WWW-Curl-4.09.ebuild,v 1.1 2009/07/10 13:23:07 tove Exp $

EAPI=2

MODULE_AUTHOR="SZBALINT"
inherit perl-module

DESCRIPTION="Perl extension interface for libcurl"

LICENSE="|| ( MPL-1.0 MPL-1.1 MIT )"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~x86"
IUSE=""

RDEPEND="net-misc/curl"
DEPEND="${RDEPEND}"

# online tests
SRC_TEST="no"
