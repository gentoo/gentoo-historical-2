# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-php/PEAR-Services_W3C_HTMLValidator/PEAR-Services_W3C_HTMLValidator-1.0.0_rc1.ebuild,v 1.1 2008/03/17 12:50:17 jokey Exp $

inherit php-pear-r1 depend.php

DESCRIPTION="Provides an object oriented interface to the API of the W3 HTML
Validator application (http://validator.w3.org/)."

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="minimal"

RDEPEND="!minimal? ( >=dev-php/PEAR-HTTP_Request-1.3.0 )"

need_php5
