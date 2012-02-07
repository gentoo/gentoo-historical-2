# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-php/PEAR-Net_DNSBL/PEAR-Net_DNSBL-1.3.6.ebuild,v 1.2 2012/02/07 17:03:19 jer Exp $

inherit php-pear-r1

DESCRIPTION="DNSBL Checker"

LICENSE="PHP-3.01"
SLOT="0"
KEYWORDS="~amd64 ~hppa ~x86"
IUSE=""
RDEPEND=">=dev-php/PEAR-Cache_Lite-1.5.2-r1
	>=dev-php/PEAR-Net_CheckIP-1.1-r1
	>=dev-php/PEAR-HTTP_Request2-2.0.0
	>=dev-php/PEAR-Net_DNS-1.0.0"
