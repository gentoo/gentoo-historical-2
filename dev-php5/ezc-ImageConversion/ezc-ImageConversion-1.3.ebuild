# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-php5/ezc-ImageConversion/ezc-ImageConversion-1.3.ebuild,v 1.3 2007/10/08 19:19:01 jokey Exp $

inherit php-ezc

DESCRIPTION="This eZ component provides a set of classes to apply different filters on images."
SLOT="0"
KEYWORDS="~amd64 ~hppa ~sparc ~x86"
IUSE=""

RDEPEND="${RDEPEND}
	>=dev-php5/ezc-ImageAnalysis-1.1.2"
