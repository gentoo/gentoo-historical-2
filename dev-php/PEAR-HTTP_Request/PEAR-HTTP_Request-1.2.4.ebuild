# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-php/PEAR-HTTP_Request/PEAR-HTTP_Request-1.2.4.ebuild,v 1.8 2005/05/02 05:06:04 vapier Exp $

inherit php-pear

DESCRIPTION="Provides an easy way to perform HTTP requests"

LICENSE="PHP"
SLOT="0"
KEYWORDS="alpha amd64 hppa ia64 ~ppc ppc64 ~sparc x86"
IUSE=""

RDEPEND=">=dev-php/PEAR-Net_URL-1.0.12
	>=dev-php/PEAR-Net_Socket-1.0.2"
