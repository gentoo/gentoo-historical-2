# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-php/PEAR-Mail/PEAR-Mail-1.1.9.ebuild,v 1.1 2005/09/29 11:32:58 sebastian Exp $

inherit php-pear-r1

DESCRIPTION="Class that provides multiple interfaces for sending emails"

LICENSE="PHP"
SLOT="0"
KEYWORDS="~sparc ~x86"
IUSE=""

RDEPEND=">=dev-php/PEAR-Net_SMTP-1.1.0"
