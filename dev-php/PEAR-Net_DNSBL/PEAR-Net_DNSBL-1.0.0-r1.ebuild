# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-php/PEAR-Net_DNSBL/PEAR-Net_DNSBL-1.0.0-r1.ebuild,v 1.8 2006/01/22 07:44:50 halcy0n Exp $

inherit php-pear-r1

DESCRIPTION="DNSBL Checker"

LICENSE="PHP"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~ppc64 ~sparc x86"
IUSE=""
RDEPEND=">=dev-php/PEAR-Cache_Lite-1.5.2-r1
	>=dev-php/PEAR-Net_CheckIP-1.1-r1
	>=dev-php/PEAR-HTTP_Request-1.2.4-r1"
