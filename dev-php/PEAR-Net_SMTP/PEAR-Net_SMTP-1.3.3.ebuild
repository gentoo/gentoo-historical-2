# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-php/PEAR-Net_SMTP/PEAR-Net_SMTP-1.3.3.ebuild,v 1.2 2010/02/16 04:55:57 beandog Exp $

inherit php-pear-r1

DESCRIPTION="An implementation of the SMTP protocol"

LICENSE="PHP-2.02"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~hppa ~ia64 ~ppc ~ppc64 ~s390 ~sh ~sparc ~x86"
IUSE="sasl"

RDEPEND=">=dev-php/PEAR-Net_Socket-1.0.7
	sasl? ( >=dev-php/PEAR-Auth_SASL-1.0.1-r1 )"
