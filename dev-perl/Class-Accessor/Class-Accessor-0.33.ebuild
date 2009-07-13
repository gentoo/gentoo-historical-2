# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-perl/Class-Accessor/Class-Accessor-0.33.ebuild,v 1.6 2009/07/13 17:48:18 josejx Exp $

EAPI=2

MODULE_AUTHOR=KASEI
inherit perl-module

DESCRIPTION="Automated accessor generation"

SLOT="0"
KEYWORDS="~alpha ~amd64 ~hppa ~ia64 ~ppc ~ppc64 ~sparc ~x86"
IUSE=""

RDEPEND="dev-perl/Sub-Name"
DEPEND="${RDEPEND}"

SRC_TEST="do"
