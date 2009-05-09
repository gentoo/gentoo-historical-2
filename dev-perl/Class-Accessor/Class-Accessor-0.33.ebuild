# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-perl/Class-Accessor/Class-Accessor-0.33.ebuild,v 1.3 2009/05/09 16:40:33 klausman Exp $

EAPI=2

MODULE_AUTHOR=KASEI
inherit perl-module

DESCRIPTION="Automated accessor generation"

SLOT="0"
KEYWORDS="~alpha ~amd64 ~hppa ~x86"
IUSE=""

RDEPEND="dev-perl/Sub-Name"
DEPEND="${RDEPEND}"

SRC_TEST="do"
